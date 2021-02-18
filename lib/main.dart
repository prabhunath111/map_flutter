import 'dart:async';
import 'dart:math';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:map_flutter/widgets/customrow.dart';
import 'button.dart';
import 'getcurrentlocation.dart';
import 'package:google_maps_webservice/places.dart' as webserv;

void main() => runApp(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.purple, cursorColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  // var getlocation = GetCurrentLocation();
  LatLngBounds bound;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(22.5726, 88.3639),
    zoom: 7,
  );

  static LatLng origin;
  static LatLng destination;
  static String originAdd = "Enter Origin";
  static String destAdd = "Enter Destination";
  static const kGoogleApiKey = "AIzaSyAUDJWykw7T79Tftb8EmXFaYRkAwr3SGRk";
  BitmapDescriptor customIcon;
  Position _currentPosition;

  // this will hold the generated polylines
  Set<Polyline> _polylines = {};

// this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];

// this is the key object - the PolylinePoints
// which generates every polyline between start and finish

  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "AIzaSyAFfkk5FtmXgIsbHQzmEXsyFOACA4Jj_oY";

// String googleAPIKey = "AIzaSyAUDJWykw7T79Tftb8EmXFaYRkAwr3SGRk";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCustomMapPin();
    //If we need to current location we have to call it otherwise not required
    // getCurrentLocation();
  }

  void setCustomMapPin() async {
    BitmapDescriptor pinLocation = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5, size: Size(16, 16)),
        'assets/images/marker.png');
    setState(() {
      customIcon = pinLocation;
    });
  }

  void _add() {
    setState(() {
      updateCameraLocation(origin, destination, mapController);
      setPolylines();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Map"),
        backgroundColor: Color(0xFF063540),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: _onMapCreated,
            trafficEnabled: true,
            //     (GoogleMapController controller) {
            //   _controller.complete(controller);
            // },
            compassEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: Set<Marker>.of(markers.values),
            onLongPress: (LatLng latLng) {
              // creating a new MARKER
              var markerIdVal = markers.length + 1;
              String mar = markerIdVal.toString();
              final MarkerId markerId = MarkerId(mar);
              final Marker marker = Marker(
                  markerId: markerId, position: latLng, icon: customIcon);
              setState(() {
                markers[markerId] = marker;
              });
            },
            polylines: _polylines,
          ),
          inputCard(),
        ],
      ),
    );
  }

  /* Future _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }*/

  Future markerC(originAdd, destAdd) async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    polylineCoordinates.clear();
    markers.clear();
    final query1 = originAdd;
    final query2 = destAdd;
    for (int i = 0; i < 2; i++) {
      if (i == 0) {
        var addresses = await Geocoder.local.findAddressesFromQuery(query1);
        var first = addresses.first;
        origin =
            LatLng(first.coordinates.latitude, first.coordinates.longitude);
      } else {
        var addresses = await Geocoder.local.findAddressesFromQuery(query2);
        var first = addresses.first;
        destination =
            LatLng(first.coordinates.latitude, first.coordinates.longitude);
      }
      // creating a new MARKER
      var markerIdVal = markers.length + 1;
      String mar = markerIdVal.toString();
      final MarkerId markerId = MarkerId(mar);
      final Marker marker = Marker(
          markerId: markerId,
          position: (i == 0) ? origin : destination,
          infoWindow: InfoWindow(
              title: (i == 0)
                  ? originAdd
                  : (i == 1)
                      ? destAdd
                      : ""),
          icon: customIcon);
      setState(() {
        markers[markerId] = marker;
        origin = origin;
        destination = destination;
      });
    }
    _add();
  }

  Widget inputCard() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.93,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF148CA6), Color(0xFF063540)],
                ),
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.panorama_fish_eye,
                                      size: 18.0,
                                      color: Colors.cyan.withOpacity(0.8)),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          _onChangedHandler("origin");
                                        },
                                        child: Text(
                                          "$originAdd",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.more_vert,
                                  color: Color(0xFFF3B0FC),
                                  size: 18.0,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1.2,
                                    // width: MediaQuery.of(context).size.width,
                                    color: Colors.cyan,
                                  ),
                                ),
                                Icon(
                                  Icons.import_export,
                                  size: 18.0,
                                  color: Colors.white,
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom:8.0),
                              child: Row(

                                children: [
                                  Icon(
                                    Icons.panorama_fish_eye,
                                    size: 18.0,
                                    color: Color(0xFFFDDEEF),
                                  ),
                                  Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: GestureDetector(
                                            onTap: () {
                                              _onChangedHandler("dest");
                                            },
                                            child: Text("$destAdd", style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0
                                            ),
                                            ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 2.0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.cyan,
                ),
                CustomRow(),
              ],
            ),
          ),
          SizedBox(
            height: 3.0,
          ),
          Container(
            // alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width * 0.93,
            // margin: EdgeInsets.only(left: 20.0, right: 20.0),
            child: RaisedGradientButton(
                child: Text(
                  'Request uberX',
                  style: TextStyle(color: Colors.white),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.pinkAccent, Colors.redAccent],
                ),
                onPressed: () => markerC(originAdd, destAdd)),
          ),
        ],
      ),
    );
  }

  Future _onChangedHandler(key) async {
    // should show search screen here
    webserv.Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        mode: Mode.overlay,
        // Mode.fullscreen
        language: "en",
        components: [webserv.Component(webserv.Component.country, "in")]);
    setState(() {
      if (key == "origin") {
        originAdd = p.description.toString();
      } else {
        destAdd = p.description.toString();
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _controller.complete(controller);
  }

  Future setPolylines() async {
    PolylineResult result = await polylinePoints?.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(origin.latitude, origin.longitude),
        PointLatLng(destination.latitude, destination.longitude),
        travelMode: TravelMode.driving);
    if (result != null) {
      result.points.forEach((point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color(0xFF5F9EA0),
          // color: Color.fromARGB(255, 40, 122, 198),
          // colors.cyan,
          points: polylineCoordinates);
      _polylines.add(polyline);
    });
  }

  Future<void> updateCameraLocation(
    LatLng source,
    LatLng destination,
    GoogleMapController mapController,
  ) async {
    if (mapController == null) return;

    LatLngBounds bounds;

    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Future<void> checkCameraLocation(
      CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }

/* Future getCurrentLocation() async{
    await getlocation.getCurrentLocation();
    _currentPosition = getlocation.currPosition;
  }*/
}
