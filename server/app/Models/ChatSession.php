<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ChatSession extends Model
{
    // Ajuste o fillable para usar o nome correto da coluna no BD:
    protected $fillable = [
        'vaga_id',
        'estudante_id',
        'empresa_id',
    ];


    public function estudante()
    {
        return $this->belongsTo(Usuario::class, 'estudante_id');
    }

    public function empresa()
    {
        return $this->belongsTo(Usuario::class, 'empresa_id');
    }

    public function vaga()
    {
        return $this->belongsTo(Vaga::class, 'vaga_id');
    }

    public function messages()
    {
        return $this->hasMany(Message::class, 'chat_session_id');
    }
}
