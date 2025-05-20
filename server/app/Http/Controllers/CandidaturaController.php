<?php

namespace App\Http\Controllers;

use App\Models\Candidatura;
use Illuminate\Http\Request;

class CandidaturaController extends Controller
{
    public function index()
    {
        return Candidatura::all();
    }

    public function show($id)
    {
        return Candidatura::findOrFail($id);
    }

    public function store(Request $request)
    {
        return Candidatura::create($request->all());
    }

    public function update(Request $request, $id)
    {
        $candidatura = Candidatura::findOrFail($id);
        $candidatura->update($request->all());
        return $candidatura;
    }

    public function destroy($id)
    {
        Candidatura::destroy($id);
        return response()->json(['mensagem' => 'Candidatura deletada']);
    }

    public function getCandidaturasByUsuario($usuarioId)
    {
        return Candidatura::where('usuario_id', $usuarioId)->get();
    }

    public function getCandidaturasByVaga($vagaId)
    {
        return Candidatura::where('vaga_id', $vagaId)->get();
    }

    public function getCandidaturasByStatus($status)
    {
        return Candidatura::where('status', $status)->get();
    }
}
