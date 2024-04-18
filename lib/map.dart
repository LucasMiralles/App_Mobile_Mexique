import 'package:app_mobile_mexique/utils/singleton.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'networkHelper.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}


class _MapState extends State<Map> {

  Singleton singleton = Singleton();

  late GoogleMapController mapController;

  late SharedPreferences shared;

  late LatLng _center = const LatLng(22.158697, -102.68745);

  //Guardar los puntos con las coordenadas (lat, lng)
  final List<LatLng> polyPoints = [];
  //Guardar las lineas sobre el mapa
  final Set<Polyline> polyLines = {};

  final List<Marker> _markers = <Marker>[];

  static const LatLng sourceLocation = LatLng(22.144596, -101.009064);
  static const LatLng destination = LatLng(22.14973, -100.992221);

  double lat = 0.0;
  double lng = 0.0;

  @override
  void initState() {
    getJsonData(); // Función que realiza el llamado a la api
    setCustomMarkerIcon(); // Se encarga de crear nuestras marcas personalizadas

    check();

    super.initState();
  }

  Future<void> check() async {
    //Instanciamos la variable
    shared = await SharedPreferences.getInstance();

    //CHECAMOS SI TIENE LA SESION ACTIVA
    if(shared.getBool('sesionActiva') ?? false) { // si es verdadadero o true
      //Ingresan a la vista principal o Home

      //Realizar el login
    }

    //Obtener los datos de Shared
    lat = shared.getDouble('lat') ?? 0.0;
    lng = shared.getDouble('lng') ?? 0.0;
  }


  void ingresar() {
    //if si existe usuario {
    shared.setString('correo', 'correo@gmail.com');
    shared.setString('password', '1234');

    shared.setBool('sesionActiva', true);
    //Ingresan a la vista principal o Home
    //}
    //else {
    shared.setString('correo', '');
    shared.setString('password', '');

    shared.setBool('sesionActiva', false);
    //}
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void actualizaCoordenadas(String lat, String lng) {
    _center = LatLng(double.parse(lat), double.parse(lng));
  }

  Future<void> getJsonData() async {
    //Llamado a la clase
    NetworkHelper networkHelper = NetworkHelper(
      startLat: 22.144596,
      startLng: -101.009064,
      endLat: 22.149730,
      endLng: -100.992221,
    );

    try {
      //print(data['features'][0]['geometry']['coordinates']); // 3er
      var data;
      //LLamado a la funcion que solicita a la api las coordenadas
      data = await networkHelper.getData();
      print(data); //json completo
      print(data["metada"]["query"]["coordinates"]);
      print(data['features']); // atributo 1er nivel
      print(data['features'][0]);
      print(data['features'][0]['geometry']); //atributo secundario
      //variable para controlar y craer la polyline que dibujaremos en el mapa
      LineString ls = LineString(data['features'][0]['geometry']['coordinates']);

      for(int i = 0; i < ls.lineString.length; i++){
        print('${ls.lineString[i][1]}, ${ls.lineString[i][0]}');
        polyPoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }

      if(polyPoints.length == ls.lineString.length) {
        setPolyLines();
      }
    } catch(e) {
      print('Hubo un error al extraer las coordenadas');
    }
  }

  setPolyLines() {
    setState(() {
      ///p1 --------- p2 ------- p3
      Polyline polyline = Polyline(
          polylineId: const PolylineId('polilyne'),
          color: Colors.red,
          width: 5,
          points: polyPoints
      );
      polyLines.add(polyline);
    });
  }

  createMarker() async {
    String iconurl ="https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/Catedral_SLP_cielo.jpg/1200px-Catedral_SLP_cielo.jpg";
    var dataBytes;
    var request = await http.get(Uri.parse(iconurl));
    var bytes = await request.bodyBytes;

    setState(() {
      dataBytes = bytes;
    });

    LatLng _lastMapPositionPoints = LatLng(
        double.parse("22.142435"),
        double.parse("-101.009346"));

    _markers.add(
        Marker(
          icon: BitmapDescriptor.fromBytes(dataBytes.buffer.asUint8List()),
          markerId: MarkerId(_lastMapPositionPoints.toString()),
          position: _lastMapPositionPoints,
          infoWindow: const InfoWindow(
            title: "Delivery Point",
            snippet:
            "My Position",
          ),
        ));
  }

  //Imagen -> Marca para visualizar en el mapa
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "img/icon.png").then((icon) {
      sourceIcon = icon;
    },
    );
  }

  getLatLng() async {
    //Dirección correcta -> las coordenadas
    List<Location> locations = await
    locationFromAddress("Av. Sierra Vista 712, las Haciendas");
    print(locations);
    print(locations[0].latitude);
    print(locations[0].longitude);
  }

  getDirection() async {
    // con coordenadas -> la dirección
    List<Placemark> placemarks = await
    placemarkFromCoordinates(52.2165157, 6.9437819);
    print(placemarks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            polylines: polyLines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers:{
              const Marker(
                markerId: MarkerId("source"),
                position: sourceLocation,
                infoWindow: InfoWindow(title: "Información inicio"),
              ),
              Marker(
                  markerId: MarkerId("destination"),
                  position: destination,
                  icon: sourceIcon,
                  infoWindow: const InfoWindow(title: "Información destino"),
                  onTap: () {
                    setState(() {
                      showAlertDialog(context);
                    });
                  }
              ),
            },
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            onCameraMove: (CameraPosition position) {
              try {
                lat = position.target.latitude;
                lng = position.target.longitude;

              } catch (e) {
                print('Get Service _createMarker: ' + e.toString());
              }
              setState(() {});
            },
          ),
          Center(
            child: Image.asset(
              'img/google.png',
              width: 64,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                return Transform.translate(
                  offset: const Offset(0, 0),
                  child: child,
                );
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton.large(
                        onPressed: () {
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const Home()));
                          });
                        },
                        child: const Text(
                          'Pasar a la siguiente vista', textAlign: TextAlign.center,
                        ),
                      ),
                      FloatingActionButton.large(
                        heroTag: '2',
                        onPressed: () {
                          setState(() {
                            getLatLng();
                          });
                        },
                        child: const Text(
                          'Obtener coordenadas', textAlign: TextAlign.center,
                        ),
                      ),
                      FloatingActionButton.large(
                        heroTag: '3',
                        onPressed: () {
                          setState(() {
                            getDirection();
                          });
                        },
                        child: const Text(
                          'Obtener la dirección', textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )

              )
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  shared.setDouble('lat', lat);
                  shared.setDouble('lng', lng);
                  _goToNewYork(lat, lng);
                });
              },
              backgroundColor: Colors.orange,
              child: Icon(Icons.location_searching_rounded),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _goToNewYork(double lat, double lng) async {
    //double lat = 40.7128;
    //double long = -74.0060;
    mapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16));
  }

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed:  () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Would you like to continue learning how to use Flutter alerts?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}