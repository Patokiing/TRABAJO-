class ModelSubCategorias {
  final int id;
  final String nombre;
  final int id_categoria;

  ModelSubCategorias(this.id, this.nombre, this.id_categoria);

  ModelSubCategorias.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nombre = json['nombre'],
        id_categoria = json['id_categoria'];
}
