import 'package:app_mobile_mexique/utils/singleton.dart';
import 'package:app_mobile_mexique/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_mexique/constantes.dart' as cons;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Log extends StatefulWidget {
  const Log({Key? key}) : super(key: key);

  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<Log> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _usuario;
  String? _contrasena;
  bool bandera = false;
  final user = TextEditingController();
  final password = TextEditingController();

  late Singleton singleton;
  late SharedPreferences prefs;

  @override
  void initState() {
    singleton = Singleton();
    initPreferences();
    checkPosition();
    super.initState();
  }

  void checkPosition() async {
    Position position = await Utils.determinePosition();
    singleton.latitud = position.latitude;
    singleton.longitud = position.longitude;
  }


  Future<void> initPreferences() async {
    prefs = await SharedPreferences.getInstance();
    checkIsLogin();
  }

  void checkIsLogin() {
    bool band = prefs.getBool('isLogin') ?? false;

    if (band) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Arrière-plan avec la couleur cons.fondo
          Container(
            width: size.width,
            height: size.height,
            color: cons.fondo,
          ),
          // Image avec le filtre
          Positioned(
            top: -320,
            left: 0,
            width: size.width,
            height: size.height / 1.25, // Hauteur de l'image ajustée
            child: Image.asset(
              "img/Welcome.png",
              fit: BoxFit.cover,
            ),
          ),
          // Filtre noir
          Positioned(
            top: -320,
            left: 0,
            width: size.width,
            height: size.height / 1.25, // Hauteur de l'image ajustée
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6),
                BlendMode.darken,
              ),
              child: Image.asset(
                "img/Welcome.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Logo centré en haut
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Opacity(
                opacity: 0.7,
                child: Image.asset(
                  "img/Logo.png",
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ),
          // Form
          Positioned(
            top: 280,
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                      child: Text(
                        'Bienvenido a Burger Classic',
                        style: TextStyle(
                          color: Color(0xFFFFA500),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: user,
                        decoration: const InputDecoration(
                          labelText: 'Correo/Usuario',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(fontSize: 25),
                        ),
                        validator: _validateNonEmpty,
                        onSaved: (value) => _usuario = value,
                      ),
                    ),
                    const SizedBox(height: 35),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: password,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(fontSize: 25),
                        ),
                        obscureText: true,
                        validator: _validateNonEmpty,
                        onSaved: (value) => _contrasena = value,
                      ),
                    ),
                    const SizedBox(height: 45),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_formKey.currentState!.validate()) {
                            if (user.text == 'lucas' && password.text == 'lucas') {
                              singleton.user = user.text;
                              singleton.password = password.text;
                              prefs.setString('user', user.text);
                              prefs.setString('pass', password.text);
                              prefs.setBool('isLogin', true);
                              // Si les identifiants et les mots de passe correspondent, naviguer vers une autre page
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const Home(), // Page de destination
                                ),
                              );
                            } else {
                              // Si les identifiants et les mots de passe ne correspondent pas, définir une variable "bandera" sur true
                              setState(() {
                                bandera = true;
                              });
                            }
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cons.naranja,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        fixedSize: Size(size.width * 0.6, 50),
                      ),
                      child: const Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          color: cons.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    bandera
                        ? const Text(
                      'Usuario o contraseña incorrectos',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    )
                        : const SizedBox(),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Olvidaste tu contraseña ?',
                        style: TextStyle(
                          color: Color(0xFFFFA500),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Validation générique pour vérifier si une chaîne est vide
  String? _validateNonEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }
}
