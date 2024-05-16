<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use App\Mail\RegisterMail;
use App\Mail\ResetPasswordMail;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\URL;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required',
            'username' => 'required',
            'email' => 'required|email|unique:users',
            'password' => 'required|min:4',
        ]);

        $user = User::create([
            'name' => $request->name,
            'username' => $request->username,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'remember_token' => Str::random(30),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        Mail::to($request->email)->send(new RegisterMail($user));

        return response()->json([
            'success' => true,
            'message' => 'Inscription reussie. Veuillez verifier votre email',
            'token' => $token,
            'token_type' => 'Bearer',
        ], 201);
    }

    public function verifyEmail($token)
    {
        $user = User::where('remember_token', $token)->first();
        if ($user) {
            if ($user->email_verified_at == null) {
                $user->email_verified_at = date('Y-m-d H:i:s');
                $user->remember_token = Str::random(30);
                $user->save();
                return view('emailVerified');

            } else {
                return view('emailAlreadyVerified');
            }
        } else {
            return view('emailTokenInvalid');
        }
    }

    public function resendVerificationEmail(Request $request)
    {
        $request->validate(['email' => 'required|email']);

        $user = User::where('email', $request->email)->first();

        if ($user) {
            if ($user->email_verified_at == null) {
                $user->remember_token = Str::random(60);
                $user->save();

                Mail::to($user->email)->send(new RegisterMail($user));

                return response()->json([
                    'success' => true,
                    'message' => 'Un nouveau lien de vérification a été envoyé à votre adresse email.',
                ], 200);
            } else {
                return response()->json([
                    'success' => false,
                    'message' => 'Votre adresse email est déjà vérifiée.',
                ], 200);
            }
        } else {
            return response()->json([
                'success' => false,
                'message' => 'Aucun utilisateur trouvé avec cette adresse email.',
            ], 404);
        }
    }

    public function login(Request $request)
    {
        $credentials = $request->validate([
            'identity' => 'required',
            'password' => 'required',
        ]);

        $fieldType = filter_var($request->identity, FILTER_VALIDATE_EMAIL) ? 'email' : 'username';
        $credentials[$fieldType] = $request->identity;
        unset($credentials['identity']);

        if (Auth::attempt($credentials) ) {
            if (Auth::user()->email_verified_at == null) {
                return response()->json(['message' => 'Merci de verifier votre email pour vous connecter'], 401);
            }

            $user = Auth::user();
            $token = $user->createToken('auth_token')->plainTextToken;

            return response()->json([
                'success' => true,
                'message' => 'Vous vous etes connecté avec succes',
                'token' => $token,
                'token_type' => 'Bearer',
            ], 201);
        }

        return response()->json(['message' => 'Utilisateur avec cette identité non trouvé'], 401);
    }

    public function forgotPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user) {
            return response()->json(['message' => 'Adresse e-mail non trouvée'], 404);
        }

        $token = Str::random(60);

        $existingResetToken = DB::table('password_reset_tokens')
            ->where('email', $user->email)
            ->first();

        if ($existingResetToken) {
            // Mettre à jour le token existant
            DB::table('password_reset_tokens')
                ->where('email', $user->email)
                ->update([
                    'token' => Str::random(60),
                    'created_at' => now(),
                ]);
        } else {
            // Créer un nouveau token
            $token = Str::random(60);

            DB::table('password_reset_tokens')->insert([
                'email' => $user->email,
                'token' => $token,
                'created_at' => now(),
            ]);
        }

        $resetUrl = URL::temporarySignedRoute('password.reset', now()->addMinutes(60), ['token' => $token]);

        Mail::to($user->email)->send(new ResetPasswordMail($resetUrl));

        return response()->json(['message' => 'Un e-mail de réinitialisation de mot de passe a été envoyé']);
    }

    public function resetPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'token' => 'required',
            'password' => 'required|min:4',
        ]);

        // Recherche de la demande de réinitialisation de mot de passe dans la base de données
        $reset = DB::table('password_resets')
            ->where('email', $request->email)
            ->where('token', $request->token)
            ->first();

        // Vérification si la demande de réinitialisation existe
        if (!$reset) {
            return response()->json(['message' => 'Demande de réinitialisation de mot de passe non valide'], 404);
        }

        // Recherche de l'utilisateur avec l'adresse e-mail associée à la demande de réinitialisation
        $user = User::where('email', $reset->email)->first();

        // Vérification si l'utilisateur existe
        if (!$user) {
            return response()->json(['message' => 'Utilisateur non trouvé'], 404);
        }

        // Mise à jour du mot de passe de l'utilisateur avec le nouveau mot de passe fourni
        $user->update([
            'password' => Hash::make($request->password),
        ]);

        // Suppression de l'entrée correspondante dans la table de réinitialisation de mot de passe
        DB::table('password_resets')->where('email', $user->email)->delete();

        return response()->json(['message' => 'Mot de passe réinitialisé avec succès']);
    }

    public function profile()
    {
        $user = Auth::user();

        return response()->json([
            'success' => true,
            'user' => $user
        ]);
    }

    public function logout()
    {
        Auth::user()->tokens()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logged out'
        ]);
    }

    public function updateProfile(Request $request)
    {
        $user = Auth::user();

        $fieldsToUpdate = $request->only(['name', 'email', 'username']);

        if (empty($fieldsToUpdate)) {
            return response()->json(['message' => 'No fields provided for update'], 400);
        }

        $request->validate([
            'name' => 'required',
            'email' => 'required|email|unique:users,email,' . $user->id,
        ]);

        $user->update($fieldsToUpdate);

        return response()->json(
            [
                'success' => true,
                'message' => 'Profile updated successfully'
            ]
        );
    }

    public function updatePassword(Request $request, $id)
    {
        $user = Auth::user();



        $request->validate([
            'current_password' => 'required',
            'new_password' => 'required|string|min:6|different:current_password',
            'confirm_password' => 'required|string|same:new_password',
        ]);

        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json(['message' => 'Current password is incorrect'], 422);
        }

        $user->update([
            'password' => Hash::make($request->new_password),
        ]);

        return response()->json(['message' => 'Password updated successfully']);
    }

    public function deleteAccount()
    {
        $user = Auth::user();

        $user->tokens()->delete();

        $user->delete();

        return response()->json([
            'success' => true,
            'message' => 'Compte supprimé avec succès'
        ]);
    }
}
