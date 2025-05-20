<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use GuzzleHttp\Client;
use GuzzleHttp\ClientInterface;
use Psr\Clock\ClockInterface;
use Symfony\Component\Clock\NativeClock;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->app->bind(ClientInterface::class, Client::class);

        $this->app->bind(ClockInterface::class, function () {
            return new NativeClock();
        });

        $this->app->singleton(
            \Illuminate\Contracts\Debug\ExceptionHandler::class,
            \App\Exceptions\Handler::class
        );

        $this->app->when(\Kreait\Firebase\Auth\ApiClient::class)
            ->needs('$projectId')
            ->give(env('FIREBASE_PROJECT_ID'));

        $this->app->when(\Kreait\Firebase\Auth\SignIn\GuzzleHandler::class)
            ->needs('$projectId')
            ->give(env('FIREBASE_PROJECT_ID'));
    }

    public function boot(): void
    {
        //
    }
}
