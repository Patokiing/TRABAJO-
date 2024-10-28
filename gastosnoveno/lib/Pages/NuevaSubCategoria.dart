import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gastosnoveno/Models/Categorias.dart';
import 'package:gastosnoveno/Models/ModelSubCategorias.dart';
import 'package:gastosnoveno/Utils/Ambiente.dart';
import 'package:http/http.dart' as http;

class NuevaSubCategoria extends StatefulWidget {
  final ModelSubCategorias? subCategoria; // Usa el modelo SubCategorias

  const NuevaSubCategoria(
      {super.key,
      this.subCategoria}); // Cambia el constructor para usar SubCategorias

  @override
  State<NuevaSubCategoria> createState() => _NuevaSubCategoriaState();
}

class _NuevaSubCategoriaState extends State<NuevaSubCategoria> {
  final TextEditingController txtNombre = TextEditingController();
  String? errorMessage;
  int? idCategoriaSeleccionada;
  List<Categorias> categorias = [];

  @override
  void initState() {
    super.initState();
    fnObtenerCategorias(); // Cargar las categorías existentes.

    // Verifica si existe una subcategoría para cargar sus datos
    if (widget.subCategoria != null) {
      txtNombre.text =
          widget.subCategoria!.nombre; // Asigna el nombre de la subcategoría
      idCategoriaSeleccionada =
          widget.subCategoria!.id_categoria; // Asigna el id de categoría
    }
  }

  // Obtener la lista de categorías del backend.
  Future<void> fnObtenerCategorias() async {
    try {
      final response = await http.get(
        Uri.parse('${Ambiente.urlServer}categorias'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          categorias = data.map((e) => Categorias.fromJson(e)).toList();
        });
      } else {
        setState(() {
          errorMessage = 'Error al cargar las categorías';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    }
  }

  // Guardar o actualizar la subcategoría.
  Future<void> fnGuardarSubCategoria() async {
    try {
      final response = await http.post(
        Uri.parse('${Ambiente.urlServer}subCategoria'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'id': widget.subCategoria?.id ?? 0, // Usa id si existe, sino 0
          'nombre': txtNombre.text,
          'id_categoria': idCategoriaSeleccionada,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Regresa con éxito.
      } else {
        setState(() {
          errorMessage = 'Error al guardar la subcategoría';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subCategoria == null
              ? 'Nueva SubCategoría'
              : 'Editar SubCategoría',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo para seleccionar la categoría principal.
            DropdownButtonFormField<int>(
              value: idCategoriaSeleccionada,
              items: categorias.map((categoria) {
                return DropdownMenuItem<int>(
                  value: categoria.id,
                  child: Text(categoria.nombre),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  idCategoriaSeleccionada = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Seleccionar Categoría',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Campo para el nombre de la subcategoría.
            TextFormField(
              controller: txtNombre,
              decoration: InputDecoration(
                labelText: 'Nombre de la SubCategoría',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (errorMessage != null) // Mostrar mensaje de error.
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ElevatedButton(
              onPressed: fnGuardarSubCategoria,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                widget.subCategoria == null ? 'Guardar' : 'Actualizar',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
