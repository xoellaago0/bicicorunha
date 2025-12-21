import 'dart:convert';

import 'package:bicicorunha/model/Station.dart';
import 'package:bicicorunha/model/StationStatus.dart';
import 'package:http/http.dart' as http;

class Apiservice {
  final String urlBase =
      "https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl";

  Future<List<Station>> buscartations() async {
    final url = Uri.parse("$urlBase/station_information");
    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final data = json.decode(respuesta.body);
      final statioJson = data['data']['stations'] as List;

      return statioJson.map((json) => Station.fromJson(json)).toList();
    } else {
      throw Exception("Error al cargar las estaciones");
    }
  }

  Future<List<Stationstatus>> buscarStationsStatus() async {
    final url = Uri.parse("$urlBase/station_status");
    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final data = json.decode(respuesta.body);
      final statioStatusjson = data['data']['stations'] as List;

      return statioStatusjson
          .map((json) => Stationstatus.fromJson(json))
          .toList();
    } else {
      throw Exception("Error al cargar el estado");
    }
  }
}
