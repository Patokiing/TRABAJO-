<?php

use App\Http\Controllers\Categoria as CategoriaController;
use App\Http\Controllers\ControllerSubCategorias;
use App\Http\Controllers\LoginController;
use App\Http\Controllers\RegisterController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('login', [LoginController::class,'login']);

Route::get('categorias', [CategoriaController::class, 'index']); 
Route::post('categoria', [CategoriaController::class, 'store']); 
Route::post('categorias', [CategoriaController::class, 'destroy']);

Route::post('register', [RegisterController::class,'register']);

Route::get('subCategorias/categoria/{id}', [ControllerSubCategorias::class, 'showByCategoryId']); 
Route::get('subCategorias', [ControllerSubCategorias::class, 'index']); 
Route::post('subCategoria', [ControllerSubCategorias::class, 'store']); 
Route::post('subCategorias', [ControllerSubCategorias::class, 'destroy']);
