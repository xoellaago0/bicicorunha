import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:bicicorunha/model/Bicicletas.dart';
import 'package:bicicorunha/model/StationEntera.dart';
import 'package:bicicorunha/model/StationStatus.dart';
import 'package:bicicorunha/service/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Inicioviewmodel {
  Apiservice api = Apiservice();
  List<Stationentera> estaciones = [];
  Stationentera? estacionfavorita;


  Future<void> cargarEstaciones() async {
    try {
      estaciones = await buscarEstaciones();
      await cargarFavorita();
    } catch (e) {
      print("Error cargando estaciones");
    }
  }

  Future<List<Stationentera>> buscarEstaciones() async {
    final listaestacion = await api.buscartations();
    final listaestado = await api.buscarStationsStatus();
    List<Stationentera> estacionesEnteras = [];

    for (var estacion in listaestacion) {
      Stationstatus? estadoEncontrado;

      for (var estado in listaestado) {
        if (estado.station_id == estacion.station_id) {
          estadoEncontrado = estado;
          break;
        }
      }

      if (estadoEncontrado == null) {
        throw Exception(
          "No se encontró estado para la estacion ${estacion.station_id}",
        );
      }
      estacionesEnteras.add(
        Stationentera(info: estacion, estado: estadoEncontrado),
      );
    }
    return estacionesEnteras;
  }

  void marcarFavorita(Stationentera estacion) {
    estacionfavorita = estacion;
  }

  Future<void> cargarFavorita() async {
    final prefs = await SharedPreferences.getInstance();
    final idFavorita = prefs.getString('favorita');
    if (idFavorita != null && estaciones.isNotEmpty) {
      try {
        estacionfavorita = estaciones.firstWhere(
          (e) => e.info.station_id == idFavorita,
        );
      } catch (e) {
        estacionfavorita = null;
      }
    } else {
      estacionfavorita = null;
    }
  }

  Future<void> setFavorita(Stationentera estacion) async {
    final prefs = await SharedPreferences.getInstance();
    if (estacionfavorita == estacion) {
      estacionfavorita = null;
      await prefs.remove('favorita');
    } else {
      estacionfavorita = estacion;
      await prefs.setString('favorita', estacion.info.station_id);
    }
  }

  Map<String, int> datosGrafica(Stationentera estacion) {

  
  final eBikes = estacion.estado.tiposBicicletas
      .where((b) => b.tipo == 'EFIT')
      .fold(0, (sum, b) => sum + b.cantidad);

 
  final mecanicas = estacion.estado.tiposBicicletas
      .where((b) => b.tipo == 'FIT')
      .fold(0, (sum, b) => sum + b.cantidad);

  
  final anclajes = estacion.estado.huecosLibres;

  final data = {
    'ebikes': eBikes,
    'mecanicas': mecanicas,
    'anclajes': anclajes,
  };

  
  if(estacionfavorita != null && estacion.estado.station_id == estacionfavorita!.estado.station_id){
    guardarGrafica(data);
  }


  return data;
}




  




  Future<void> guardarGrafica(Map<String, int> data) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('fav_ebikes', data['ebikes']!);
    await prefs.setInt('fav_mecanicas', data['mecanicas']!);
    await prefs.setInt('fav_anclajes', data['anclajes']!);
  }

String compensarBajar(Stationentera estacion) {
  final eBikes = estacion.estado.tiposBicicletas
      .firstWhere((b) => b.tipo == 'EFIT', orElse: () => Bicicletas(tipo: 'EFIT', cantidad: 0))
      .cantidad;

  final mecanicas = estacion.estado.tiposBicicletas
      .firstWhere((b) => b.tipo == 'FIT', orElse: () => Bicicletas(tipo: 'FIT', cantidad: 0))
      .cantidad;

  if (eBikes >= 1) {
    return "Sí";
  } else if (mecanicas > 0) {
    return "Quizá";
  } else {
    return "No";
  }
}

  String frescuraDatos(DateTime ultimaActualizacion) {
  final minutos = DateTime.now().difference(ultimaActualizacion).inMinutes;

  if (minutos <= 5) return "Datos de hace 5 minutos o menos";
  if (minutos <= 15) return "Datos de hace entre 5 y 15 minutos";
  return "Datos desactualizados de más de 15 minutos";
}

List<Map<String,dynamic>> top3Estaciones(){
  List<Stationentera> ordenadas = List.from(estaciones);
  ordenadas.sort((a,b){
      int totalA = a.estado.tiposBicicletas.fold(0,(sum, b) => sum + b.cantidad);
      int totalB = b.estado.tiposBicicletas.fold(0,(sum, b) => sum + b.cantidad);
      return totalB.compareTo(totalA);
  });

  List<Stationentera> top3 = ordenadas.take(3).toList();

  return top3.map((e){
    int ebikes = e.estado.tiposBicicletas
    .where((b) => b.tipo.toUpperCase()== 'EFIT')
    .fold(0, (sum, b) => sum + b.cantidad);

    int mecanicas = e.estado.tiposBicicletas
    .where((b) => b.tipo.toUpperCase()== 'FIT')
    .fold(0, (sum, b) => sum + b.cantidad);

    return {
      'nombre': e.info.nombre,
      'ebikes': ebikes,
      'mecanicas': mecanicas,
    };
  }).toList();


}

}
