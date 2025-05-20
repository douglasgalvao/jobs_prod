<?php

use App\Http\Controllers\ChatController;
use App\Http\Controllers\ChatSessionController;
use App\Http\Controllers\MessageController;
use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/


// * AuthController
Route::post('auth/register', [\App\Http\Controllers\AuthController::class, 'register']);

Route::post('create-session', [ChatController::class, 'store']);
Route::post('auth/login', [\App\Http\Controllers\AuthController::class, 'login']);
Route::post('auth/login/firebase', [\App\Http\Controllers\AuthController::class, 'loginWithFirebase']); // Firebase
Route::middleware(['auth:sanctum'])->group(function () {
    Route::prefix('empresas')->middleware([\App\Http\Middleware\EmpresaValida::class])->group(function () {
        Route::post('/vagas/cadastrar', [\App\Http\Controllers\EmpresaController::class, 'store']);
    });

    Route::post('send-message', [MessageController::class, 'sendMessage']);
    Route::get('chat-sessions/{sessionId}/history', [MessageController::class, 'mountHistoryBySessionId']);

    Route::prefix('estudantes')->middleware([\App\Http\Middleware\EstudanteValido::class])->group(function () {
        Route::get('/curriculo', [\App\Http\Controllers\EstudanteController::class, 'carregarCurriculo']);
        Route::post('/curriculo', [\App\Http\Controllers\EstudanteController::class, 'salvarCurriculo']);
    });
});




// Route::post('/tokens/create', function (Request $request) {
//     $token = $request->user()->createToken($request->token_name);

//     return ['token' => $token->plainTextToken];
// });

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');
Route::get('debug', fn() => response()->json(['status' => 'online']));
