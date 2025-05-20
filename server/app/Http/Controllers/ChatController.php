<?php

namespace App\Http\Controllers;

use App\Events\MessageSent;
use App\Models\Message;
use Illuminate\Http\Request;

class ChatController extends Controller
{


    public function store(Request $request)
    {
        $validated = $request->validate([
            'vaga_id' => 'required|exists:vagas,id',
            'estudante_id' => 'required|exists:usuarios,id',
            'empresa_id' => 'required|exists:usuarios,id',
        ]);

        $chatSession = \App\Models\ChatSession::create($validated);

        return response()->json($chatSession, 201);
    }

}
