import 'package:flutter/material.dart';
import 'package:app_mobile_mexique/constantes.dart' as cons;
import 'log.dart';
import 'register.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.darken,
            ),
            child: Image.asset(
              "img/Welcome.png",
              width: size.width,
              height: size.height,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 60,
            left: 10,
            child: Image.asset(
              "img/Logo.png",
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.125),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Log()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: cons.naranja,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  fixedSize: Size(size.width * 0.6, 45),
                ),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    color: cons.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.045),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No tienes una cuenta ? ',
                    style: TextStyle(color: cons.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const Register(), // Page de destination
                        ),
                      );
                    },
                    child: Text(
                      'Registrate',
                      style: TextStyle(
                        color: cons.naranja.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2.0,
                        decorationColor: cons.naranja.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
