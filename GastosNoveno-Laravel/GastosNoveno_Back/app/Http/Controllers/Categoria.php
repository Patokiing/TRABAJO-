<?php

namespace App\Http\Controllers;

use App\Models\ModelCategoria;
use Illuminate\Http\Request;

class Categoria extends Controller
{
    public function index()
    {
        return ModelCategoria::all();
    }

    public function store(Request $req)
    {
       if ($req->id != 0) {
           $categoria = ModelCategoria::find($req->id);
        } else {
            $categoria = new ModelCategoria();
        }

        $categoria->nombre = $req->nombre;
        $categoria->id_usuario = $req->id_usuario;
        $categoria->save();

        return 'OK';
    }

    public function destroy(Request $request)
    {

        $categoria = ModelCategoria::findOrFail($request->id);
        $categoria->delete();

        return 'OK';
    }

}
