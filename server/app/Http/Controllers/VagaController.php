<?php

namespace App\Http\Controllers;

use App\Models\Vaga;
use Illuminate\Http\Request;

class VagaController extends Controller
{
    public function index()
    {
        return Vaga::all();
    }

    public function show($id)
    {
        return Vaga::findOrFail($id);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'titulo' => 'required|string|max:255',
            'descricao' => 'required|string',
            'requisitos' => 'nullable|string',
        ]);
        $empresa = Auth::user()->empresa;

        if (!$empresa) {
            return response()->json(['mensagem' => 'Empresa não encontrada'], 404);
        }
    
        $vaga = [
            'empresa_id' => $empresa->id,
            'titulo' => $data['titulo'],
            'descricao' => $data['descricao'],
            'requisitos' => $data['requisitos'],
            'data_publicacao' => now(),
        ];

        Vaga::create($vaga);

        return response()->json([
            'mensagem' => 'Vaga criada com sucesso',
            'vaga' => $vaga,
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $vaga = Vaga::findOrFail($id);
        $vaga->update($request->all());
        return $vaga;
    }

    public function destroy($id)
    {
        Vaga::destroy($id);
        return response()->json(['mensagem' => 'Vaga deletada']);
    }
}
