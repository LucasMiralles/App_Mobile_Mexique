import 'package:geolocator/geolocator.dart';

class Utils {

  // Méthode pour obtenir la position actuelle
  static Future<Position> determinePosition() async {
    // Vérifier si les services de localisation sont activés
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      throw Exception('Les services de localisation sont désactivés.');
    }

    // Vérifier les autorisations de localisation
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Les autorisations de localisation sont refusées.');
      }
    } else if (permission == LocationPermission.deniedForever) {
      throw Exception('Les autorisations de localisation sont refusées de façon permanente.');
    }

    // Obtenir la position actuelle
    return await Geolocator.getCurrentPosition();
  }
}
