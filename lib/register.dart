import 'package:flutter/material.dart';
import 'package:app_mobile_mexique/constantes.dart' as cons;
import 'home.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _nombreCompleto;
  String? _correo;
  String? _direccion;
  String? _contrasena;
  bool bandera = false;
  final user = TextEditingController();
  final pass = TextEditingController();

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
            height: size.height / 1.25,
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
            height: size.height / 1.25,
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
            top: 15,
            left: 0,
            right: 0,
            child: Center(
              child: Opacity(
                opacity: 0.7,
                child: Image.asset(
                  "img/Logo.png",
                  width: 140,
                  height: 140,
                ),
              ),
            ),
          ),
          // Form
          Positioned.fill(
            top: 220,
            left: 20,
            right: 20,
            child: SingleChildScrollView(
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
                      SizedBox(height: 60),
                      const Text(
                        'Bienvenido al Registro',
                        style: TextStyle(
                          color: Color(0xFFFFA500),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: user,
                        decoration: InputDecoration(
                          labelText: 'Nombre Completo',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF800080),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: _validateNonEmpty,
                        onSaved: (value) => _nombreCompleto = value,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Correo',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(
                                  0xFF800080), // Couleur de la surbrillance
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: _validateNonEmpty,
                        onSaved: (value) => _correo = value,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Dirección de envío',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF800080),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: _validateNonEmpty,
                        onSaved: (value) => _direccion = value,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: pass,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF800080),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: const Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: _validateNonEmpty,
                        onSaved: (value) => _contrasena = value,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_formKey.currentState!.validate()) {
                              if (user.text == 'lucas' &&
                                  pass.text == 'lucas') {
                                // Si les identifiants et les mots de passe correspondent, naviguer vers une autre page
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const Home(), // Page de destination
                                  ),
                                );
                              } else {
                                // Si les identifiants et les mots de passe ne correspondent pas, définir une variable "bandera" sur true

                                bandera = true;
                              }
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: cons.naranja,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          fixedSize: Size(size.width * 0.6, 45),
                        ),
                        child: const Text(
                          'Registrarse',
                          style: TextStyle(
                            color: cons.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      bandera
                          ? const Text(
                              'Usuario o contraseña incorrectos',
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            )
                          : const SizedBox(),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Políticas de Privacidad',
                          style: TextStyle(
                            color: const Color(0xFFFFA500),
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            decorationThickness: 2.0,
                            decorationColor: cons.naranja.withOpacity(0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 170,
            left: size.width * 0.5 - 50,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red, width: 3),
                color: Colors.grey[300],
              ),
              child: Icon(
                Icons.add,
                size: 50,
                color: Colors.grey[600],
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
