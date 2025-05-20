<?php

namespace App\Http\Controllers;

use App\Models\ChatSession;
use App\Models\Vaga;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ChatSessionController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'vaga_id' => 'required|exists:vagas,id',
            'student_id' => 'required|exists:usuarios,id',
        ]);

        $empresaId = Auth::id();

        $vaga = Vaga::where('id', $request->vaga_id)
                    ->where('empresa_id', $empresaId)
                    ->first();

        if (!$vaga) {
            return response()->json(['error' => 'Vaga não encontrada para essa empresa'], 404);
        }


        $chatSession = ChatSession::firstOrCreate([
            'vaga_id' => $request->vaga_id,
            'student_id' => $request->student_id,
            'empresa_id' => $empresaId,
        ]);

        return response()->json($chatSession, 201);
    }

    // Empresa lista sessões abertas para uma vaga dela
    public function index($vagaId)
    {
        $empresaId = Auth::id();

        $vaga = Vaga::where('id', $vagaId)
                    ->where('empresa_id', $empresaId)
                    ->first();

        if (!$vaga) {
            return response()->json(['error' => 'Vaga não encontrada para essa empresa'], 404);
        }

        $sessions = ChatSession::where('vaga_id', $vagaId)
                               ->where('empresa_id', $empresaId)
                               ->with('student') // carregando dados do estudante
                               ->get();

        return response()->json($sessions);
    }

    // Estudante lista as sessões de chat que participa
    public function indexForStudent()
    {
        $studentId = Auth::id();

        $sessions = ChatSession::where('student_id', $studentId)
                               ->with('vaga', 'empresa') // carregar vaga e empresa relacionadas
                               ->get();

        return response()->json($sessions);
    }
}
