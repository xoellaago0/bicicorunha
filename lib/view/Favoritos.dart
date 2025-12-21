import 'dart:async';

import 'package:bicicorunha/model/Bicicletas.dart';
import 'package:bicicorunha/model/StationEntera.dart';
import 'package:bicicorunha/view/Detalles.dart';
import 'package:bicicorunha/viewmodel/inicioViewModel.dart';
import 'package:flutter/material.dart';

class Favoritos extends StatefulWidget {
  final Inicioviewmodel inicioviewmodel;
  const Favoritos({super.key, required this.inicioviewmodel});

  @override
  State<Favoritos> createState() => FavoritosState();
}

class FavoritosState extends State<Favoritos> {
  late Inicioviewmodel inicioviewmodel;
Timer? timer;

  @override
  void initState() {
    super.initState();
    inicioviewmodel = widget.inicioviewmodel;
    cargarDatos();

    timer = Timer.periodic(Duration(seconds: 10), (_){
      cargarDatos();
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

    if (!mounted) return;

    setState(() {
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    'ESTACIONES',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 41, 57, 58),
                    ),
                  ),
                ),
              ),

              for (var estacionEntera in widget.inicioviewmodel.estaciones)
                Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(estacionEntera.info.nombre),
                        subtitle: Text(
                          "Dirección: ${estacionEntera.info.direccion}",
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            inicioviewmodel.estacionfavorita == estacionEntera
                                ? Icons.star
                                : Icons.star_border,
                          ),
                          onPressed: () async {
                            await inicioviewmodel.setFavorita(estacionEntera);
                            setState(() {});
                          },
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_)=> Detalles(estacionSeleccionada: estacionEntera),));
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
