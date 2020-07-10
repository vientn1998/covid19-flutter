import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:template_flutter/src/models/user_model.dart';

class MapPage extends StatefulWidget {

  List<UserObj> listDoctor = [];
  MapPage({@required this.listDoctor});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  Completer<GoogleMapController> _controller = Completer();
  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;

  static final CameraPosition initLocation = CameraPosition(
    target: LatLng(0.0, 0.0)
  );

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    loadAllMarkerDoctor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: initLocation,
              markers: _markers,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              
            ),
            Positioned(
              bottom: 26,
              right: 16,
              child: ClipOval(
                child: Material(
                  color: Colors.orange[100],
                  child: InkWell(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(Icons.my_location),
                    ),
                    onTap: _goToTheLake,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: 56,
              child: ClipOval(
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(Icons.arrow_back),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  elevation: 1,
                ),
              ),
            )
          ],
        ),
      )
    );
  }
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
        CameraUpdate.newLatLng(LatLng(48.8589507, 2.2770205))
    );
  }


  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  Future<void> _getCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      final Uint8List markerIcon = await getBytesFromAsset('assets/images/ic_marker_current.png', 100);
      setState(() {
        _currentPosition = position;
//        controller.animateCamera(
//          CameraUpdate.newCameraPosition(
//            CameraPosition(
//              bearing: 0,
//              target: LatLng(position.latitude, position.longitude),
//              tilt: 50.0,
//              zoom: 16.0,
//            ),
//          ),
//        );

        _markers.add(Marker(
          markerId: MarkerId(position.toString()),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(
            title: 'Here you are',
          ),
          icon: BitmapDescriptor.fromBytes(markerIcon),
        ));
      });
    }).catchError((e) {
      print(e);
    });
  }
  
  Future<void> loadAllMarkerDoctor() async {
    print("loadAllMarkerDoctor: ${widget.listDoctor.length}");
    final Uint8List markerIcon = await getBytesFromAsset('assets/images/ic_marker_red.png', 70);
    widget.listDoctor.forEach((doctor) async{
      setState(() {
        _markers.add(Marker(
          markerId: MarkerId(doctor.id),
          position: LatLng(doctor.location.latitude, doctor.location.longitude),
          infoWindow: InfoWindow(
            title: doctor.name,
          ),
          icon: BitmapDescriptor.fromBytes(markerIcon),
        ));
      });
    });
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(getBounds(_markers.toList()), 50)
    );
  }

  LatLngBounds getBounds(List<Marker> markers) {
    var lngs = markers.map<double>((m) => m.position.longitude).toList();
    var lats = markers.map<double>((m) => m.position.latitude).toList();
    double topMost = lngs.reduce(max);
    double leftMost = lats.reduce(min);
    double rightMost = lats.reduce(max);
    double bottomMost = lngs.reduce(min);

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );
    return bounds;
  }

}
