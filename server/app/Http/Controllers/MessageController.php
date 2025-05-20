<?php

namespace App\Http\Controllers;

use App\Events\MessageSent;
use App\Models\Message;
use App\Models\ChatSession;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class MessageController extends Controller
{
    // Listar mensagens de uma sessão de chat
    public function index($sessionId)
    {
        $userId = Auth::id();
        $session = ChatSession::findOrFail($sessionId);

        if (!in_array($userId, [$session->empresa_id, $session->estudante_id])) {
            return response()->json(['error' => 'Acesso negado'], 403);
        }

        $messages = Message::where('chat_session_id', $sessionId)
            ->orderBy('created_at', 'asc')
            ->get();

        return response()->json($messages);
    }

    

    public function store(Request $request, $sessionId)
    {
        $request->validate([
            'message' => 'required|string',
        ]);

        $userId = Auth::id();
        $session = ChatSession::findOrFail($sessionId);

        if (!in_array($userId, [$session->empresa_id, $session->estudante_id])) {
            return response()->json(['error' => 'Acesso negado'], 403);
        }

        $receiverId = ($userId === $session->empresa_id)
            ? $session->estudante_id
            : $session->empresa_id;

        $message = Message::create([
            'chat_session_id' => $sessionId,
            'sender_id' => $userId,
            'receiver_id' => $receiverId,
            'message' => $request->message,
        ]);

        broadcast(new MessageSent($message))->toOthers();

        return response()->json($message, 201);
    }



    public function sendMessage(Request $request)
    {
        try {

            $messages = [
                'chat_session_id.required' => 'A sessão de chat é obrigatória.',
                'chat_session_id.exists' => 'Sessão de chat não encontrada.',

                'sender_id.required' => 'O remetente é obrigatório.',
                'sender_id.exists' => 'Remetente não encontrado.',

                'receiver_id.required' => 'O destinatário é obrigatório.',
                'receiver_id.exists' => 'Destinatário não encontrado.',

                'content.required' => 'A mensagem é obrigatória.',
                'content.string' => 'A mensagem deve ser um texto.',
            ];

            $validated = $request->validate([
                'chat_session_id' => 'required|exists:chat_sessions,id',
                'sender_id' => 'required|exists:usuarios,id',
                'receiver_id' => 'required|exists:usuarios,id',
                'content' => 'required|string',
            ], $messages);

            $userId = Auth::id();

            $session = ChatSession::find($validated['chat_session_id']);


            if (!$session) {
                return response()->json(['error' => 'Sessão de chat não encontrada'], 404);
            }

            if (!in_array($userId, [$session->empresa_id, $session->estudante_id])) {
                return response()->json(['error' => 'Acesso negado, usuário não pertence a essa sessão'], 403);
            }

            $message = Message::create([
                'chat_session_id' => $validated['chat_session_id'],
                'sender_id' => $validated['sender_id'],
                'receiver_id' => $validated['receiver_id'],
                'content' => $validated['content'],
            ]);

            broadcast(new MessageSent($message))->toOthers();

            return response()->json($message, 201);

        } catch (ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Erro de validação',
                'errors' => $e->errors()
            ], 422);
        }
    }

    private function findMessageBySenderId($senderId)
    {
        $messages = Message::where('sender_id', $senderId)->get();

        if ($messages->isEmpty()) {
            return response()->json(['message' => 'Nenhuma mensagem encontrada'], 404);
        }

        return response()->json($messages);
    }

    private function findMessageByReceiverId($receiverId)
    {
        $messages = Message::where('receiver_id', $receiverId)->get();

        if ($messages->isEmpty()) {
            return response()->json(['message' => 'Nenhuma mensagem encontrada'], 404);
        }

        return response()->json($messages);
    }
    private function findMessageByChatSessionId($chatSessionId)
    {
        $messages = Message::where('chat_session_id', $chatSessionId)->get();

        if ($messages->isEmpty()) {
            return response()->json(['message' => 'Nenhuma mensagem encontrada'], 404);
        }

        return response()->json($messages);
    }

    public function mountHistoryBySessionId($sessionId)
    {
        $userId = Auth::id();
        $session = ChatSession::findOrFail($sessionId);

        if (!in_array($userId, [$session->empresa_id, $session->estudante_id])) {
            return response()->json(['error' => 'Acesso negado, usuário não pertence a essa sessão (history messages)'], 403);
        }

        $messages = Message::where('chat_session_id', $sessionId)
            ->orderBy('created_at', 'asc')
            ->get();

        return response()->json($messages);
    }


}
