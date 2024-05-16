<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class ResetPasswordController extends Controller
{
    public function showResetForm(Request $request, $token = null)
    {
        // $token = $request->query('token');
        // dd($token);
        return view('resetPasswordForm', compact('token'))->with('token', $token);
    }

    public function resetPassword(Request $request)
    {
        $request->validate([
            'token' => 'required',
            'password' => 'required|min:4',
        ]);

        $reset = DB::table('password_reset_tokens')->where('token', $request->token)->first();

        if (!$reset) {
            return response()->json(['message' => 'Token de réinitialisation de mot de passe invalide'], 404);
        }

        $user = User::where('email', $reset->email)->first();

        if (!$user) {
            return response()->json(['message' => 'Utilisateur non trouvé'], 404);
        }

        $user->update([
            'password' => Hash::make($request->password),
        ]);

        DB::table('password_reset_tokens')->where('email', $user->email)->delete();

        return response()->json(['message' => 'Mot de passe mis à jour avec succès']);
    }
}
