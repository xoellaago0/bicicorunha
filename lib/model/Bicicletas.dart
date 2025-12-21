import 'dart:io';

class Bicicletas {
  String tipo;
  int cantidad;

  Bicicletas({required this.tipo, required this.cantidad});

  factory Bicicletas.fromJson(Map<String, dynamic> json) {
    return Bicicletas(tipo: json["vehicle_type_id"], cantidad: json["count"]);
  }
}
