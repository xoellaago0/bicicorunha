import 'dart:async';

import 'package:bicicorunha/view/Favoritos.dart';
import 'package:bicicorunha/view/Inicio.dart';
import 'package:bicicorunha/viewmodel/inicioViewModel.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  final Inicioviewmodel inicioviewmodel = Inicioviewmodel();


  int paginaSeleccionada = 0;

  final List<String> titulos = ["Inicio", "Estaciones"];

  @override
  Widget build(BuildContext context) {
    final List<Widget> paginas = [
      Inicio(inicioviewmodel: inicioviewmodel),
      Favoritos(inicioviewmodel: inicioviewmodel),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(titulos[paginaSeleccionada])),
      body: paginas[paginaSeleccionada],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 50,
        backgroundColor: Color(0xFFD8E0E7),
        unselectedItemColor: Color.fromARGB(255, 67, 93, 94),
        selectedItemColor: Color.fromARGB(255, 52, 74, 75),
        selectedLabelStyle: TextStyle(color: Color.fromARGB(255, 67, 93, 94)),
        unselectedLabelStyle: TextStyle(color: Color.fromARGB(255, 67, 93, 94)),

        currentIndex: paginaSeleccionada,
        onTap: (index) {
          setState(() => paginaSeleccionada = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, color: Color(0xFF547071)),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star, color: Color(0xFF547071)),
            label: 'Estaciones',
          ),
        ],
      ),
    );
  }
}
