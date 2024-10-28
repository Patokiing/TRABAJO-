import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gastosnoveno/Models/ModelSubCategorias.dart'; // Ensure this model matches your JSON structure
import 'package:gastosnoveno/Utils/Ambiente.dart';
import 'package:http/http.dart' as http;

import 'NuevaSubCategoria.dart';

class SubCategorias extends StatefulWidget {
  final int categoriaId; // Corrected type for categoriaId

  const SubCategorias({super.key, required this.categoriaId});

  @override
  State<SubCategorias> createState() => _SubCategoriasState();
}

class _SubCategoriasState extends State<SubCategorias> {
  List<ModelSubCategorias> subCategorias = []; // Use the correct model
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fnObtenerSubCategorias(); // Load subcategories on initialization
  }

  Future<void> fnObtenerSubCategorias() async {
    try {
      final response = await http.get(
        Uri.parse(
            '${Ambiente.urlServer}subCategorias/categoria/${widget.categoriaId}'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        // Map JSON response to ModelSubCategorias objects
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          subCategorias =
              data.map((item) => ModelSubCategorias.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar subcategorías')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subcategorías"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : subCategorias.isEmpty
              ? const Center(child: Text('No hay subcategorías disponibles.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: subCategorias.length,
                  itemBuilder: (context, index) {
                    final subCategoria = subCategorias[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      child: ListTile(
                        title: Text(
                          subCategoria
                              .nombre, // Ensure 'nombre' exists in ModelSubCategorias
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // Navigate to edit screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NuevaSubCategoria(
                                      subCategoria:
                                          subCategoria, // Pass the selected subcategory
                                    ),
                                  ),
                                ).then((value) {
                                  if (value ?? false) {
                                    fnObtenerSubCategorias(); // Refresh the list after editing
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                fnEliminarSubCategoria(subCategoria
                                    .id); // Pass the ID of the selected subcategory
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> fnEliminarSubCategoria(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${Ambiente.urlServer}subCategorias/$id'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subcategoría eliminada con éxito')),
        );
        fnObtenerSubCategorias(); // Refresh the list after deletion
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar la subcategoría')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
