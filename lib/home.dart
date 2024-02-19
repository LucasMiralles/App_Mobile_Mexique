import 'package:app_mobile_mexique/drawer.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_mexique/constantes.dart' as cons;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: cons.fondo,
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'img/Welcome.png',
            width: size.width * 0.1,
          ),
        ),
        backgroundColor: cons.fondo,
        // elevation: 10,
        //shadowColor: Colors.white,
        iconTheme: const IconThemeData(color: cons.white),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.local_grocery_store),
          ),
        ],
      ),
      drawer: const CustomDrawer(), // Utilisation de CustomDrawer ici
    );
  }
}
