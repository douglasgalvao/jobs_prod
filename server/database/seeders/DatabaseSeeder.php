<?php

namespace Database\Seeders;

use App\Models\Usuario;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        Usuario::factory()->create([
            'nome' => 'admin',
            'email' => 'admin@email.com',
            'tipo' => 'admin',
            'senha' => 'admin',
        ]);
        Usuario::factory(10)->create();
    }
}
