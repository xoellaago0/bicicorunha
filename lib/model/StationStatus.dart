import 'dart:io';

import 'package:bicicorunha/model/Bicicletas.dart';

class Stationstatus {
  String station_id;
  int bicicletasDisponible;
  int bicicletasFueraServicio;
  String estadoEstacion;
  int huecosLibres;
  int huecosFueraServicio;
  bool puedesSacar;
  bool puedesDevolver;
  DateTime fechaActualizacion;

  List<Bicicletas> tiposBicicletas;

  Stationstatus({
    required this.station_id,
    required this.bicicletasDisponible,
    required this.bicicletasFueraServicio,
    required this.estadoEstacion,
    required this.huecosLibres,
    required this.huecosFueraServicio,
    required this.puedesSacar,
    required this.puedesDevolver,
    required this.fechaActualizacion,
    required this.tiposBicicletas,
  });

  factory Stationstatus.fromJson(Map<String, dynamic> json) {
    return Stationstatus(
      station_id: json["station_id"],
      bicicletasDisponible: json["num_bikes_available"] ?? 0,
      bicicletasFueraServicio: json["num_bikes_disabled"] ?? 0,
      estadoEstacion: json["status"] ?? "UNKNOWN",
      huecosLibres: json["num_docks_available"] ?? 0,
      huecosFueraServicio: json["num_docks_disabled"] ?? 0,
      puedesSacar: json["is_renting"] ?? false,
      puedesDevolver: json["is_returning"] ?? false,
      fechaActualizacion: json["last_reported"] != null
      ? DateTime.fromMillisecondsSinceEpoch(
        json["last_reported"] * 1000,
        isUtc: true
      ).toLocal() : DateTime.now(),
      tiposBicicletas: (json["vehicle_types_available"] as List<dynamic>? ?? [])
          .map(
            (e) => Bicicletas(
              tipo: e["vehicle_type_id"] ?? "desconocido",
              cantidad: e["count"] ?? 0,
            ),
          )
          .toList(),
    );
  }
}
