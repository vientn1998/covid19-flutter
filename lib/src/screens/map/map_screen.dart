import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/screens/doctor/choose_schedule_screen.dart';
import 'package:template_flutter/src/screens/doctor/doctor_details_screen.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/hex_color.dart';

class MapPage extends StatefulWidget {

  List<UserObj> listDoctor = [];
  MapPage({@required this.listDoctor});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  Completer<GoogleMapController> _controller = Completer();
  CarouselController carouselController;
  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;
  bool isShowPager = false;
  int indexSelected = 0;
  static List<UserObj> listData = [];
  static var contextBuilder;

  static final CameraPosition initLocation = CameraPosition(
    target: LatLng(0.0, 0.0)
  );

  final Set<Marker> _markers = {};

  @override
  void initState() {
    carouselController = CarouselController();
    super.initState();
    listData.addAll(widget.listDoctor);
    isShowPager = false;
    contextBuilder = context;
    _getCurrentLocation();
  }

  @override
  void dispose() {
    super.dispose();
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
              onTap: (location) {
                if (isShowPager) {
                  setState(() {
                    isShowPager = false;
                  });
                }
              },
            ),
            Positioned(
              top: 120,
              right: 16,
              child: ClipOval(
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(Icons.zoom_out_map),
                    ),
                    onTap: () async {
                      if (isShowPager) {
                        setState(() {
                          isShowPager = false;
                        });
                      }
                      final GoogleMapController controller = await _controller.future;
                      controller.animateCamera(
                          CameraUpdate.newLatLngBounds(getBounds(_markers.toList()), 80)
                      );
                    },
                  ),
                  elevation: 2,
                ),
              ),
            ),
            Positioned(
              top: 56,
              right: 16,
              child: ClipOval(
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(Icons.my_location),
                    ),
                    onTap: _goToMyLocation,
                  ),
                  elevation: 2,
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
                  elevation: 2,
                ),
              ),
            ),
            isShowPager ? Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: paddingDefault),
                child: CarouselSlider(
                  carouselController: carouselController,
                  options: CarouselOptions(
                    height: 175.0,
                    viewportFraction: 0.9,
                    enableInfiniteScroll: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) async {
                      final GoogleMapController mapController = await _controller.future;
                      final latlng = LatLng(listData[index].location.latitude, listData[index].location.longitude);
                      mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            bearing: 0.0,
                            target: latlng,
                            tilt: 30.0,
                            zoom: 17.0,
                          ),
                        ),
                      );
                    }
                  ),
                  items: itemSlider,
                ),
              ),
            ) : SizedBox(height: 0, width: 0,),
          ],
        ),
      )
    );
  }

  final List<Widget> itemSlider = listData.map((doctor) {
    return Container(
      margin: EdgeInsets.fromLTRB(4,8,4,8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(1, 1),
            )
          ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 70,
                  width: 70,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipOval(
                      child: buildImageAvatar(doctor),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(width: 10,),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(doctor.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: textColor),),
                      SizedBox(height: 2,),
                      Text(doctor.getNameMajor(),maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor),),
                      SizedBox(height: 6,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.assignment, color: textColor, size: 16,),
                              Text('100',style: TextStyle(
                                  fontSize: 14, color: textColor, fontWeight: FontWeight.w500
                              ),),
                            ],
                          ),
                          SizedBox(width: 20,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.star, color: Colors.yellow, size: 18,),
                              Text('4.5',style: TextStyle(
                                  fontSize: 14, color: textColor, fontWeight: FontWeight.w500
                              ),),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2,),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 36,
                      width: 70,
                      child: OutlineButton(
                        borderSide: BorderSide(color: Colors.blue),
                        child: Text('Book', style: TextStyle(
                            fontSize: 14, color: textColor
                        ),),
                        onPressed: () {
                          Navigator.push(contextBuilder, MaterialPageRoute(
                            builder: (context) => ScheduleDoctorPage(userObjReceiver: doctor,),
                          ));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: BorderSide(color: Colors.blue)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: heightSpaceSmall,),
                  Expanded(
                    child: Container(
                      height: 36,
                      width: 70,
                      child: OutlineButton(
                        borderSide: BorderSide(color: Colors.blue),
                        child: Text('Directer', style: TextStyle(
                            fontSize: 14, color: textColor
                        ),),
                        onPressed: () {

                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: heightSpaceSmall,),
                  Expanded(
                    child: Container(
                      height: 36,
                      width: 70,
                      child: OutlineButton(
                        borderSide: BorderSide(color: Colors.blue),
                        child: Text('Details', style: TextStyle(
                            fontSize: 14, color: textColor
                        ),),
                        onPressed: () {
                          Navigator.push(contextBuilder, MaterialPageRoute(
                            builder: (context) => DoctorDetailsPage(userObj: doctor,),
                          ));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }).toList();

  static buildImageAvatar(UserObj item) {
    if (item.avatar != null) {
      return CachedNetworkImage(
        imageUrl: item.avatar,
        fit: BoxFit.cover,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Center(
          child: FaIcon(FontAwesomeIcons.user),
        ),
      );
    } else {
      return Center(
        child: FaIcon(FontAwesomeIcons.user),
      );
    }
  }

  Future<void> _goToMyLocation() async {
    if (isShowPager) {
      setState(() {
        isShowPager = false;
      });
    }
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          tilt: 30.0,
          zoom: 18.0,
        ),
      ),
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
        _markers.add(Marker(
          markerId: MarkerId(position.toString()),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(
            title: 'Here you are',
          ),
          icon: BitmapDescriptor.fromBytes(markerIcon),
        ));
        loadAllMarkerDoctor();
      });
    }).catchError((e) {
      print(e);
    });
  }
  
  Future<void> loadAllMarkerDoctor() async {
    print("loadAllMarkerDoctor: ${widget.listDoctor.length}");
    final GoogleMapController mapController = await _controller.future;
    final Uint8List markerIcon = await getBytesFromAsset('assets/images/ic_marker_red.png', 70);
    widget.listDoctor.asMap().forEach((index, doctor) async{
      final latlng = LatLng(doctor.location.latitude, doctor.location.longitude);
      setState(() {
        _markers.add(Marker(
          markerId: MarkerId(doctor.id),
          draggable: false,
          position: latlng,
          icon: BitmapDescriptor.fromBytes(markerIcon),
            infoWindow: InfoWindow(
              title: doctor.name,
            ),
          onTap: () {
            mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  bearing: 0.0,
                  target: latlng,
                  tilt: 30.0,
                  zoom: 17.0,
                ),
              ),
            );
            print('index: $index');
            if (!isShowPager) {
              setState(() {
                isShowPager = true;
              });
              Timer(Duration(milliseconds: 1000), () {
                carouselController.jumpToPage(index);
              });
            } else {
              Timer(Duration(milliseconds: 1000), () {
                carouselController.jumpToPage(index);
              });
            }
          }
        ));
      });
    });
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(getBounds(_markers.toList()), 80)
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
