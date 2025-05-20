<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Candidatura extends Model
{
    protected $fillable = ['vaga_id', 'curriculo_id', 'data_candidatura', 'status'];

    public function vaga()
    {
        return $this->belongsTo(Vaga::class);
    }

    public function curriculo()
    {
        return $this->belongsTo(Curriculo::class);
    }
}
