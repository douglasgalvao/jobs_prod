<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Vaga extends Model
{
    protected $table = 'vagas';

    protected $fillable = ['empresa_id', 'titulo', 'descricao', 'requisitos', 'data_publicacao'];

    public function empresa()
    {
        return $this->belongsTo(Empresa::class);
    }

    public function candidaturas()
    {
        return $this->hasMany(Candidatura::class);
    }
}
