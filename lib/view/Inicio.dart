import 'dart:async';

import 'package:bicicorunha/model/Bicicletas.dart';
import 'package:bicicorunha/model/StationEntera.dart';
import 'package:bicicorunha/view/GraficoBarras.dart';
import 'package:bicicorunha/viewmodel/inicioViewModel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  final Inicioviewmodel inicioviewmodel;
  const Inicio({super.key, required this.inicioviewmodel});

  @override
  State<Inicio> createState() => InicioState();
}

class InicioState extends State<Inicio> {
  late Inicioviewmodel inicioviewmodel;
  Timer? timer;
  bool bajar = false;


  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
    
  
    inicioviewmodel = widget.inicioviewmodel;
    cargarDatos();
    timer = Timer.periodic(Duration(seconds: 15), (_) {
      cargarDatos();
    });
     });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  bool cargando = true;

  void cargarDatos() async {
    await widget.inicioviewmodel.cargarEstaciones();
    setState(() {
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (inicioviewmodel.estacionfavorita == null) {
      return Center(child: Text('No hay estación favorita'));
    }

    final pieData = inicioviewmodel.datosGrafica(
      inicioviewmodel.estacionfavorita!,
    );

    final top3 = inicioviewmodel.top3Estaciones();

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blueGrey[300],
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    'Estación Favorita',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 41, 57, 58),
                    ),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        inicioviewmodel.estacionfavorita?.info.nombre ??
                            "No hay estacion favorita",
                      ),
                      subtitle: Text(
                        "Dirección: ${inicioviewmodel.estacionfavorita?.info.direccion ?? "Ninguna"}\n${inicioviewmodel.frescuraDatos(inicioviewmodel.estacionfavorita!.estado.fechaActualizacion)}",
                      ),
                      onTap: () => setState(() {
                        inicioviewmodel.estacionfavorita?.isExpanded =
                            !(inicioviewmodel.estacionfavorita?.isExpanded ??
                                false);
                      }),
                    ),
                    if (inicioviewmodel.estacionfavorita?.isExpanded ?? false)
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Código Postal: ${inicioviewmodel.estacionfavorita?.info.codigoPostal ?? '-'}",
                            ),
                            Text(
                              "Bicis disponibles: ${inicioviewmodel.estacionfavorita?.estado.bicicletasDisponible}",
                            ),
                            Text(
                              "E-bikes: ${inicioviewmodel.estacionfavorita?.estado.tiposBicicletas.firstWhere((b) => b.tipo == 'EFIT', orElse: () => Bicicletas(tipo: 'EFIT', cantidad: 0)).cantidad}",
                            ),
                            Text(
                              "Huecos libres: ${inicioviewmodel.estacionfavorita?.estado.huecosLibres}",
                            ),
                            Text(
                              "Última actualización: ${inicioviewmodel.estacionfavorita?.estado.fechaActualizacion}",
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  children: [
                    ListTile(
                      title: Text("ME CONVIENE BAJAR?", style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        inicioviewmodel.compensarBajar(
                          inicioviewmodel.estacionfavorita!,
                        ),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)
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
                            Text("Quizás: No hay bicis eléctricas pero hay bicis normales"),
                            Text("No hay bicis"),
                          ],
                        ),
                      ),
                    },
                  ],
                ),
              ),
              
              Container(
                height: 320,
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Column(children: [
                      Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 10)),
                    Text("Bicicletas eléctricas, mecánicas y anclajes libres en ${inicioviewmodel.estacionfavorita!.info.nombre}",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 250,
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
                        title: 'Anclajes Libres: ${pieData['anclajes']}',
                        titleStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        color: Colors.green,
                      ),
                    ],
                  ),
                ))],),
              ),
              Container(
                height: 370,
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Text("Top 3 estaciones con más bicicletas desglosado en eléctricas y mecánicas",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                    Graficobarras(data: top3),
                    Padding(padding: EdgeInsetsGeometry.only(left: 100),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          
                          Icon(Icons.square,color: Colors.red,),
                          Text("Mecanicas"),
                          Icon(Icons.square,color: Colors.blueGrey,),
                          Text("Ebikes"),
                        ],
                      ))
                  ],
                )
                
               
              ),
            ],
          ),
        ),
      ),
    );
  }
}
