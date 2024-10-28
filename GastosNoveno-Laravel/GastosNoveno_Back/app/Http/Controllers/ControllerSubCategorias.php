<?php

namespace App\Http\Controllers;

use App\Models\subCategorias;
use Illuminate\Http\Request;

class ControllerSubCategorias extends Controller
{
    public function index()
    {
        return subCategorias::all();
    }

    public function store(Request $req)
    {
        if ($req->id != 0) {
            $subCategoria = subCategorias::find($req->id);
        } else {
            $subCategoria = new subCategorias();
        }

        $subCategoria->nombre = $req->nombre;
        $subCategoria->id_categoria = $req->id_categoria;
        $subCategoria->save();

        return 'OK';
    }

    public function showByCategoryId($id)
    {
    
        $subCategorias = subCategorias::where('id_categoria', $id)->get();

        return response()->json($subCategorias);
    }


    public function destroy(Request $request)
    {

        $subCategoria = subCategorias::findOrFail($request->id);
        $subCategoria->delete();

        return 'OK';
    }
}
