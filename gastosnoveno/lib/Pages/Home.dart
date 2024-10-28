import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gastosnoveno/Models/Categorias.dart';
import 'package:gastosnoveno/Pages/NuevaCategoria.dart';
import 'package:gastosnoveno/Pages/NuevaSubCategoria.dart';
import 'package:gastosnoveno/Pages/SubCategoria.dart';
import 'package:gastosnoveno/Utils/Ambiente.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Categorias> categorias = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fnObtenerCategorias();
  }

  void fnObtenerCategorias() async {
    try {
      final response = await http.get(
        Uri.parse('${Ambiente.urlServer}categorias'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      if (response.statusCode == 200) {
        Iterable mapCategorias = jsonDecode(response.body);
        setState(() {
          categorias = List<Categorias>.from(
            mapCategorias.map((model) => Categorias.fromJson(model)),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar las categorías')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fnEliminarCategoria(int id) async {
    try {
      final response = await http.post(
        Uri.parse('${Ambiente.urlServer}categorias'),
        body: jsonEncode(<String, dynamic>{'id': id}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoría eliminada exitosamente')),
        );
        fnObtenerCategorias(); // Refresca la lista después de eliminar
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar la categoría')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _listViewCategorias() {
    if (categorias.isEmpty) {
      return const Center(child: Text('No hay categorías disponibles.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        final categoria = categorias[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
          child: ListTile(
            title: Text(
              categoria.nombre,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NuevaCategoria(categoria: categoria),
                      ),
                    );
                    if (result == true) {
                      fnObtenerCategorias(); // Refresca la lista después de editar
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    fnEliminarCategoria(categoria.id); // Lógica para eliminar
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SubCategorias(categoriaId: categoria.id),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categorías"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _listViewCategorias(),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.category),
            backgroundColor: Colors.green,
            label: 'Agregar Categoría',
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NuevaCategoria(),
                ),
              );
              if (result == true) {
                fnObtenerCategorias();
              }
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.subdirectory_arrow_right),
            backgroundColor: Colors.orange,
            label: 'Agregar Subcategoría',
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NuevaSubCategoria(),
                ),
              );

              print("Agregar Subcategoría");
            },
          ),
        ],
      ),
    );
  }
}
