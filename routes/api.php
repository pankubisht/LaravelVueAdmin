<?php

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




Route::middleware('auth:api')->group( function () {
    Route::resource('roles','Api\RoleController');
    
    Route::get('/verify','Api\UserController@verify');
    Route::post('/emailVerify','Api\UserController@emailVerify');
    Route::post('/user/role','Api\UserController@changeRole');
    Route::post('/user/photo','Api\UserController@changePhoto');

    Route::post('roles/delete','Api\RoleController@deleteAll');
   
    
});

Route::resource('users','Api\UserController');
Route::post('users/delete','Api\UserController@deleteAll');

Route::post('login','Api\UserController@login')->name('login');



 

