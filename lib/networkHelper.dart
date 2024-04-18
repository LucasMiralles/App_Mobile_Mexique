import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper({
    required this.startLng,
    required this.startLat,
    required this.endLng,
    required this.endLat,
  });

  final String url = 'https://api.openrouteservice.org/v2/directions/';
  final String apiKey = '5b3ce3597851110001cf62485e22467c62274b79897348352ab67a37';
  final String journeyMode = 'driving-car';
  final double startLng;
  final double startLat;
  final double endLng;
  final double endLat;

  Future getData() async{
    http.Response response = await http.get(Uri.parse('$url$journeyMode?'
        'api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat'));
    print("$url$journeyMode?$apiKey&start=$startLng,$startLat&end=$endLng,$endLat");


    if(response.statusCode == 200) {
      String data = response.body;
      print(data);
      return jsonDecode(data);
    }
    else{
      print(response.statusCode);
    }
  }
}

class Colores {
  Colores({required this.nombre});

  final String nombre;
  final String url ='http://nrweb.com.mx/api_prueba/colores.php';

  Future getColores() async {

    http.Response response = await http.get(Uri.parse('$url?nombre=$nombre'));
    print('$url?nombre=$nombre');

    if(response.statusCode == 200) {
      String data = response.body;
      print(data);
      return jsonDecode(data);
    }
    else{
      print(response.statusCode);
    }
  }
}
