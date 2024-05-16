<?php

namespace App\Http\Controllers;

use App\Models\Employe;
use App\Http\Requests\StoreEmployeRequest;
use App\Http\Requests\UpdateEmployeRequest;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;

class EmployeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $user = Auth::user();
        $employees = $user->employes; // Supposant que vous ayez une relation nommée "employees" dans votre modèle User

        return response()->json([
            'success' => true,
            'employes' => $employees
        ], 200);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreEmployeRequest $request)
    {
        $user = Auth::user();
        $employe = new Employe($request->validated());
        $user->employes()->save($employe);

        return response()->json([
            'success' => true,
            'message' => 'Employe created successfully',
            'employe' => $employe
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Employe $employe)
    {
        // return response()->json([
        //     'success' => true,
        //     'employe' => $employe
        // ]);

        return $employe;
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Employe $employe)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateEmployeRequest $request, Employe $employe)
    {
        $employe->update($request->validated());

        return response()->json([
            'message' => 'Employee updated successfully',
            'employe' => $employe
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Employe $employe)
    {
        $employe->delete();

        return response()->json(['message' => 'Employee deleted successfully']);
    }

    public function search(Request $request)
    {
        $user = Auth::user();
        $query = $user->employes();

        if ($request->has('search')) {
            $searchTerm = $request->input('search');
            $query->where(function ($query) use ($searchTerm) {
                $query->where('lastname', 'like', "%$searchTerm%")
                      ->orWhere('firstname', 'like', "%$searchTerm%");
            });
        }

        $employees = $query->get();

        return response()->json([
            'success' => true,
            'employes' => $employees
        ], 200);
    }
}
