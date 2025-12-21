import 'dart:io';

class Station {
  String station_id;
  String nombre;
  String direccion;
  String? codigoPostal;
  int capacidad;
  double lat;
  double lon;

  Station({
    required this.station_id,
    required this.nombre,
    required this.direccion,
    required this.codigoPostal,
    required this.capacidad,
    required this.lat,
    required this.lon,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      station_id: json["station_id"],
      nombre: json["name"],
      direccion: json["address"] ?? "",
      codigoPostal: json["post_code"],
      capacidad: json["capacity"],
      lat: json["lat"].toDouble(),
      lon: json["lon"].toDouble(),
    );
  }
}
