<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('name')->comment('Имя пользователя');
            $table->string('email')->unique()->comment('Email адрес пользователя');
            $table->timestamp('email_verified_at')->nullable()->comment('Дата верификации email');
            $table->string('password')->comment('Хеш пароля');
            $table->rememberToken()->comment('Токен "запомнить меня"');
            $table->timestamps();
        });

        Schema::create('password_reset_tokens', function (Blueprint $table) {
            $table->string('email')->primary()->comment('Email для сброса пароля');
            $table->string('token')->comment('Токен сброса пароля');
            $table->timestamp('created_at')->nullable()->comment('Дата создания токена');
        });

        Schema::create('sessions', function (Blueprint $table) {
            $table->string('id')->primary()->comment('Уникальный идентификатор сессии');
            $table->foreignId('user_id')->nullable()->index()->comment('ID пользователя');
            $table->string('ip_address', 45)->nullable()->comment('IP адрес пользователя');
            $table->text('user_agent')->nullable()->comment('User Agent браузера');
            $table->longText('payload')->comment('Данные сессии');
            $table->integer('last_activity')->index()->comment('Время последней активности');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
        Schema::dropIfExists('password_reset_tokens');
        Schema::dropIfExists('sessions');
    }
};
