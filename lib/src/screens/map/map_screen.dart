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
import 'package:template_flutter/src/models/location_model.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/screens/doctor/choose_schedule_screen.dart';
import 'package:template_flutter/src/screens/doctor/doctor_details_screen.dart';
import 'package:template_flutter/src/utils/calculate.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/dialog_cus.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';

class MapPage extends StatefulWidget {

  List<UserObj> listDoctor = [];
  bool isFromMain = true;
  MapPage({@required this.listDoctor,this.isFromMain = true});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  Completer<GoogleMapController> _controller = Completer();
  CarouselController carouselController;
  static Position _currentPosition;
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
                          CameraUpdate.newLatLngBounds(getBounds(_markers.toList()), widget.isFromMain ? 80 : 100)
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
                    height: 180.0,
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
                  items: listData.map((doctor) {
                    final distance = calculateDistance(_currentPosition.latitude, _currentPosition.longitude, doctor.location.latitude, doctor.location.longitude).toStringAsFixed(1);
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
                                  height: 60,
                                  width: 60,
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
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(doctor.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: textColor),),
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
                                                  SizedBox(width: 20,),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Icon(Icons.location_on, color: colorIcon, size: 18,),
                                                      Text('$distance Km',style: TextStyle(
                                                          fontSize: 14, color: textColor, fontWeight: FontWeight.w500
                                                      ),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          IconButton(
                                            icon: Icon(Icons.directions, color: Colors.blue,size: 28,),
                                            onPressed: () {
                                            },
                                          )
                                        ],
                                      ),

                                      SizedBox(height: 6,),
                                      Text(doctor.getNameMajor(),maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15,),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      height: 36,
                                      child: FlatButton(
                                        color: Colors.blue,
                                        child: Text('Book', style: TextStyle(
                                            fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold
                                        ),),
                                        onPressed: () {
                                          Navigator.push(contextBuilder, MaterialPageRoute(
                                            builder: (context) => ScheduleDoctorPage(userObjReceiver: doctor,),
                                          ));
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                            side: BorderSide(color: Colors.blue)
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: paddingDefault,),
                                  Expanded(
                                    child: Container(
                                      height: 36,
                                      child: OutlineButton(
                                        child: Text('Details', style: TextStyle(
                                            fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold
                                        ),),
                                        onPressed: () {
                                          Navigator.push(contextBuilder, MaterialPageRoute(
                                            builder: (context) => DoctorDetailsPage(userObj: doctor,),
                                          ));
                                        },
                                        borderSide: BorderSide(color: Colors.blue),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
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
                  }).toList(),
                ),
              ),
            ) : SizedBox(height: 0, width: 0,),
          ],
        ),
      )
    );
  }

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
    try {
      final dataMap = await SharePreferences().getObject(SharePreferenceKey.location);
      if (dataMap != null) {
        final data = LocationObj.fromJson(dataMap);
        if (data != null) {
          final Uint8List markerIcon = await getBytesFromAsset('assets/images/ic_marker_current.png', 100);
          final position = Position(latitude: data.latitude, longitude: data.longitude);
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
        }
      }
    }catch (error) {
      toast("Error get location current");
    }

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
          onTap: () {
            print('index: $index');
            if (widget.isFromMain) {
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
        ));
      });
    });
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(getBounds(_markers.toList()), widget.isFromMain ? 80 : 100)
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
