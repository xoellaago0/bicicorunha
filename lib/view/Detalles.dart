import 'dart:async';

import 'package:bicicorunha/model/Bicicletas.dart';
import 'package:bicicorunha/model/StationEntera.dart';
import 'package:bicicorunha/viewmodel/detalleviremodel.dart';
import 'package:bicicorunha/viewmodel/inicioViewModel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Detalles extends StatefulWidget {
  final Stationentera estacionSeleccionada;

  const Detalles({super.key, required this.estacionSeleccionada});

  @override
  State<Detalles> createState() => DetallesState();
}

class DetallesState extends State<Detalles> {
  late Stationentera estacionSeleccionada;
  bool bajar = false;

  @override
  void initState() {
    super.initState();
    estacionSeleccionada = widget.estacionSeleccionada;
  }

  final Inicioviewmodel inicioviewmodel = Inicioviewmodel();
  final DetalleViewModel detalleViewModel = DetalleViewModel();

  @override
  Widget build(BuildContext context) {
    final pieData = inicioviewmodel.datosGrafica(estacionSeleccionada);

    return Scaffold(
      appBar: AppBar(title: Text("DETALLES DE LA ESTACIÓN")),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blueGrey[300],
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Center(
                  child: Text(
                    estacionSeleccionada.info.nombre,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "ME CONVIENE BAJAR?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        inicioviewmodel.compensarBajar(estacionSeleccionada),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () => setState(() {
                        bajar = !bajar;
                      }),
                    ),
                    if (bajar) ...{
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Sí: Hay bicicletas eléctricas disponibles"),
                            Text(
                              "Quizás: No hay bicis eléctricas pero hay bicis normales",
                            ),
                            Text("No hay bicis"),
                          ],
                        ),
                      ),
                    },
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      vertical: 20,
                      horizontal: 25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inicioviewmodel.frescuraDatos(
                            estacionSeleccionada.estado.fechaActualizacion,
                          ),
                        ),
                        Text(
                          "Código Postal: ${estacionSeleccionada.info.codigoPostal ?? '-'}",
                        ),
                        Text(
                          "Bicis disponibles: ${estacionSeleccionada.estado.bicicletasDisponible}",
                        ),
                        Text(
                          "E-bikes: ${estacionSeleccionada.estado.tiposBicicletas.firstWhere((b) => b.tipo == 'EFIT', orElse: () => Bicicletas(tipo: 'EFIT', cantidad: 0)).cantidad}",
                        ),
                        Text(
                          "Huecos libres: ${estacionSeleccionada.estado.huecosLibres}",
                        ),
                        Text(
                          "Última actualización: ${estacionSeleccionada.estado.fechaActualizacion}",
                        ),Padding(padding: EdgeInsetsGeometry.only(left: 100), 
                        child: Text("Bicicletas eléctricas, mecánicas y anclajes libres en ${estacionSeleccionada.info.nombre}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            height: 250,
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 10,
                            ),
                            child: PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    value: pieData['ebikes']!.toDouble(),
                                    title: 'E-bikes: ${pieData['ebikes']}',
                                    titleStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    color: Colors.blueGrey,
                                  ),
                                  PieChartSectionData(
                                    value: pieData['mecanicas']!.toDouble(),
                                    title: 'Mecánicas: ${pieData['mecanicas']}',
                                    titleStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    color: Colors.red,
                                  ),
                                  PieChartSectionData(
                                    value: pieData['anclajes']!.toDouble(),
                                    title:
                                        'Anclajes Libres: ${pieData['anclajes']}',
                                    titleStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () =>
                    detalleViewModel.generarPdf(estacionSeleccionada),
                icon: Icon(Icons.picture_as_pdf),
                label: Text('Generar PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
