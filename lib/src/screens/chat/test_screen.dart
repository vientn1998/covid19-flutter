import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceCirclePage extends StatefulWidget {
  @override
  _PlaceCirclePageState createState() => _PlaceCirclePageState();
}

class _PlaceCirclePageState extends State<PlaceCirclePage> {
  GoogleMapController controller;
  Map<CircleId, Circle> circles = <CircleId, Circle>{};
  int _circleIdCounter = 1;
  CircleId selectedCircle;

  // Values when toggling circle color
  int fillColorsIndex = 0;
  int strokeColorsIndex = 0;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];

  // Values when toggling circle stroke width
  int widthsIndex = 0;
  List<int> widths = <int>[10, 20, 5];

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onCircleTapped(CircleId circleId) {
    setState(() {
      selectedCircle = circleId;
    });
  }

  void _remove() {
    setState(() {
      if (circles.containsKey(selectedCircle)) {
        circles.remove(selectedCircle);
      }
      selectedCircle = null;
    });
  }

  void _add() {
    final int circleCount = circles.length;

    if (circleCount == 12) {
      return;
    }

    final String circleIdVal = 'circle_id_$_circleIdCounter';
    _circleIdCounter++;
    final CircleId circleId = CircleId(circleIdVal);

    final Circle circle = Circle(
      circleId: circleId,
      consumeTapEvents: true,
      strokeColor: Colors.orange,
      fillColor: Colors.green,
      strokeWidth: 5,
      center: _createCenter(),
      radius: 50000,
      onTap: () {
        _onCircleTapped(circleId);
      },
    );

    setState(() {
      circles[circleId] = circle;
    });
  }

  void _toggleVisible() {
    final Circle circle = circles[selectedCircle];
    setState(() {
      circles[selectedCircle] = circle.copyWith(
        visibleParam: !circle.visible,
      );
    });
  }

  void _changeFillColor() {
    final Circle circle = circles[selectedCircle];
    setState(() {
      circles[selectedCircle] = circle.copyWith(
        fillColorParam: colors[++fillColorsIndex % colors.length],
      );
    });
  }

  void _changeStrokeColor() {
    final Circle circle = circles[selectedCircle];
    setState(() {
      circles[selectedCircle] = circle.copyWith(
        strokeColorParam: colors[++strokeColorsIndex % colors.length],
      );
    });
  }

  void _changeStrokeWidth() {
    final Circle circle = circles[selectedCircle];
    setState(() {
      circles[selectedCircle] = circle.copyWith(
        strokeWidthParam: widths[++widthsIndex % widths.length],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: SizedBox(
              width: 350.0,
              height: 300.0,
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(52.4478, -3.5402),
                  zoom: 7.0,
                ),
                circles: Set<Circle>.of(circles.values),
                onMapCreated: _onMapCreated,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('add'),
                            onPressed: _add,
                          ),
                          FlatButton(
                            child: const Text('remove'),
                            onPressed: (selectedCircle == null) ? null : _remove,
                          ),
                          FlatButton(
                            child: const Text('toggle visible'),
                            onPressed:
                            (selectedCircle == null) ? null : _toggleVisible,
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('change stroke width'),
                            onPressed: (selectedCircle == null)
                                ? null
                                : _changeStrokeWidth,
                          ),
                          FlatButton(
                            child: const Text('change stroke color'),
                            onPressed: (selectedCircle == null)
                                ? null
                                : _changeStrokeColor,
                          ),
                          FlatButton(
                            child: const Text('change fill color'),
                            onPressed: (selectedCircle == null)
                                ? null
                                : _changeFillColor,
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LatLng _createCenter() {
    final double offset = _circleIdCounter.ceilToDouble();
    return _createLatLng(51.4816 + offset * 0.2, -3.1791);
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }
}

class AnimateCamera extends StatefulWidget {
  const AnimateCamera();
  @override
  State createState() => AnimateCameraState();
}

class AnimateCameraState extends State<AnimateCamera> {
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 400.0,
              child: GoogleMap(
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                initialCameraPosition:
                const CameraPosition(target: LatLng(0.0, 0.0)),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          const CameraPosition(
                            bearing: 270.0,
                            target: LatLng(51.5160895, -0.1294527),
                            tilt: 30.0,
                            zoom: 17.0,
                          ),
                        ),
                      );
                    },
                    child: const Text('newCameraPosition'),
                  ),
                  FlatButton(
                    onPressed: () {
                      mapController.animateCamera(
                        CameraUpdate.newLatLng(
                          const LatLng(56.1725505, 10.1850512),
                        ),
                      );
                    },
                    child: const Text('newLatLng'),
                  ),
                  FlatButton(
                    onPressed: () {
                      mapController.animateCamera(
                        CameraUpdate.newLatLngBounds(
                          LatLngBounds(
                            southwest: const LatLng(16.061182, 108.234653),
                            northeast: const LatLng(15.361438, 108.824514),
                          ),
                          10.0,
                        ),
                      );
                    },
                    child: const Text('newLatLngBounds'),
                  ),
                  FlatButton(
                    onPressed: () {
                      mapController.animateCamera(
                        CameraUpdate.newLatLngZoom(
                          const LatLng(37.4231613, -122.087159),
                          11.0,
                        ),
                      );
                    },
                    child: const Text('newLatLngZoom'),
                  ),
                  FlatButton(
                    onPressed: () {
                      mapController.animateCamera(
                        CameraUpdate.scrollBy(150.0, -225.0),
                      );
                    },
                    child: const Text('scrollBy'),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      mapController.animateCamera(
                        CameraUpdate.zoomBy(
                          0.5,
                          const Offset(0.0, 0.0),
                        ),
                      );
                    },
                    child: const Text('zoomBy with focus'),
                  ),
                  FlatButton(
                    onPressed: () {
                      mapController.animateCamera(
                        CameraUpdate.zoomBy(-0.5),
                      );
                    },
                    child: const Text('zoomBy'),
                  ),
                  FlatButton(
                    onPressed: () {
                      mapController.animateCamera(
                        CameraUpdate.zoomIn(),
                      );
                    },
                    child: const Text('zoomIn'),
                  ),
                  FlatButton(
                    onPressed: () {
                      mapController.animateCamera(
                        CameraUpdate.zoomOut(),
                      );
                    },
                    child: const Text('zoomOut'),
                  ),
                  FlatButton(
                    onPressed: () {
                      mapController.animateCamera(
                        CameraUpdate.zoomTo(16.0),
                      );
                    },
                    child: const Text('zoomTo'),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SnapshotPage extends StatefulWidget {
  @override
  _SnapshotPageState createState() => _SnapshotPageState();
}

class _SnapshotPageState extends State<SnapshotPage> {
  static final LatLng center = const LatLng(-33.86711, 151.1947171);

  GoogleMapController controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  void _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                actions: <Widget>[
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
                content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 66),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Old position: ${tappedMarker.position}'),
                        Text('New position: $newPosition'),
                      ],
                    )));
          });
    }
  }

  void _add() {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        center.latitude + sin(_markerIdCounter * pi / 6.0) / 20.0,
        center.longitude + cos(_markerIdCounter * pi / 6.0) / 20.0,
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        _onMarkerTapped(markerId);
      },
      onDragEnd: (LatLng position) {
        _onMarkerDragEnd(markerId, position);
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _remove() {
    setState(() {
      if (markers.containsKey(selectedMarker)) {
        markers.remove(selectedMarker);
      }
    });
  }

  void _changePosition() {
    final Marker marker = markers[selectedMarker];
    final LatLng current = marker.position;
    final Offset offset = Offset(
      center.latitude - current.latitude,
      center.longitude - current.longitude,
    );
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        positionParam: LatLng(
          center.latitude + offset.dy,
          center.longitude + offset.dx,
        ),
      );
    });
  }

  void _changeAnchor() {
    final Marker marker = markers[selectedMarker];
    final Offset currentAnchor = marker.anchor;
    final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        anchorParam: newAnchor,
      );
    });
  }

  Future<void> _changeInfoAnchor() async {
    final Marker marker = markers[selectedMarker];
    final Offset currentAnchor = marker.infoWindow.anchor;
    final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        infoWindowParam: marker.infoWindow.copyWith(
          anchorParam: newAnchor,
        ),
      );
    });
  }

  Future<void> _toggleDraggable() async {
    final Marker marker = markers[selectedMarker];
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        draggableParam: !marker.draggable,
      );
    });
  }

  Future<void> _toggleFlat() async {
    final Marker marker = markers[selectedMarker];
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        flatParam: !marker.flat,
      );
    });
  }

  Future<void> _changeInfo() async {
    final Marker marker = markers[selectedMarker];
    final String newSnippet = marker.infoWindow.snippet + '*';
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        infoWindowParam: marker.infoWindow.copyWith(
          snippetParam: newSnippet,
        ),
      );
    });
  }

  Future<void> _changeAlpha() async {
    final Marker marker = markers[selectedMarker];
    final double current = marker.alpha;
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        alphaParam: current < 0.1 ? 1.0 : current * 0.75,
      );
    });
  }

  Future<void> _changeRotation() async {
    final Marker marker = markers[selectedMarker];
    final double current = marker.rotation;
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        rotationParam: current == 330.0 ? 0.0 : current + 30.0,
      );
    });
  }

  Future<void> _toggleVisible() async {
    final Marker marker = markers[selectedMarker];
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        visibleParam: !marker.visible,
      );
    });
  }

  Future<void> _changeZIndex() async {
    final Marker marker = markers[selectedMarker];
    final double current = marker.zIndex;
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        zIndexParam: current == 12.0 ? 0.0 : current + 1.0,
      );
    });
  }

// A breaking change to the ImageStreamListener API affects this sample.
// I've updates the sample to use the new API, but as we cannot use the new
// API before it makes it to stable I'm commenting out this sample for now
// TODO(amirh): uncomment this one the ImageStream API change makes it to stable.
// https://github.com/flutter/flutter/issues/33438
//
//  void _setMarkerIcon(BitmapDescriptor assetIcon) {
//    if (selectedMarker == null) {
//      return;
//    }
//
//    final Marker marker = markers[selectedMarker];
//    setState(() {
//      markers[selectedMarker] = marker.copyWith(
//        iconParam: assetIcon,
//      );
//    });
//  }
//
//  Future<BitmapDescriptor> _getAssetIcon(BuildContext context) async {
//    final Completer<BitmapDescriptor> bitmapIcon =
//        Completer<BitmapDescriptor>();
//    final ImageConfiguration config = createLocalImageConfiguration(context);
//
//    const AssetImage('assets/red_square.png')
//        .resolve(config)
//        .addListener(ImageStreamListener((ImageInfo image, bool sync) async {
//      final ByteData bytes =
//          await image.image.toByteData(format: ImageByteFormat.png);
//      final BitmapDescriptor bitmap =
//          BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
//      bitmapIcon.complete(bitmap);
//    }));
//
//    return await bitmapIcon.future;
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: SizedBox(
              width: double.maxFinite,
              height: 400.0,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(-33.852, 151.211),
                  zoom: 11.0,
                ),
                // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                // https://github.com/flutter/flutter/issues/28312
                // ignore: prefer_collection_literals
                markers: Set<Marker>.of(markers.values),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('add'),
                            onPressed: _add,
                          ),
                          FlatButton(
                            child: const Text('remove'),
                            onPressed: _remove,
                          ),
                          FlatButton(
                            child: const Text('change info'),
                            onPressed: _changeInfo,
                          ),
                          FlatButton(
                            child: const Text('change info anchor'),
                            onPressed: _changeInfoAnchor,
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('change alpha'),
                            onPressed: _changeAlpha,
                          ),
                          FlatButton(
                            child: const Text('change anchor'),
                            onPressed: _changeAnchor,
                          ),
                          FlatButton(
                            child: const Text('toggle draggable'),
                            onPressed: _toggleDraggable,
                          ),
                          FlatButton(
                            child: const Text('toggle flat'),
                            onPressed: _toggleFlat,
                          ),
                          FlatButton(
                            child: const Text('change position'),
                            onPressed: _changePosition,
                          ),
                          FlatButton(
                            child: const Text('change rotation'),
                            onPressed: _changeRotation,
                          ),
                          FlatButton(
                            child: const Text('toggle visible'),
                            onPressed: _toggleVisible,
                          ),
                          FlatButton(
                            child: const Text('change zIndex'),
                            onPressed: _changeZIndex,
                          ),
                          // A breaking change to the ImageStreamListener API affects this sample.
                          // I've updates the sample to use the new API, but as we cannot use the new
                          // API before it makes it to stable I'm commenting out this sample for now
                          // TODO(amirh): uncomment this one the ImageStream API change makes it to stable.
                          // https://github.com/flutter/flutter/issues/33438
                          //
                          // FlatButton(
                          //   child: const Text('set marker icon'),
                          //   onPressed: () {
                          //     _getAssetIcon(context).then(
                          //       (BitmapDescriptor icon) {
                          //         _setMarkerIcon(icon);
                          //       },
                          //     );
                          //   },
                          // ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlacePolygonBody extends StatefulWidget {
  const PlacePolygonBody();

  @override
  State<StatefulWidget> createState() => PlacePolygonBodyState();
}

class PlacePolygonBodyState extends State<PlacePolygonBody> {
  GoogleMapController controller;
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 1;
  PolylineId selectedPolyline;

  // Values when toggling polyline color
  int colorsIndex = 0;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];

  // Values when toggling polyline width
  int widthsIndex = 0;
  List<int> widths = <int>[10, 20, 5];

  int jointTypesIndex = 0;
  List<JointType> jointTypes = <JointType>[
    JointType.mitered,
    JointType.bevel,
    JointType.round
  ];

  // Values when toggling polyline end cap type
  int endCapsIndex = 0;
  List<Cap> endCaps = <Cap>[Cap.buttCap, Cap.squareCap, Cap.roundCap];

  // Values when toggling polyline start cap type
  int startCapsIndex = 0;
  List<Cap> startCaps = <Cap>[Cap.buttCap, Cap.squareCap, Cap.roundCap];

  // Values when toggling polyline pattern
  int patternsIndex = 0;
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[],
    <PatternItem>[
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)],
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)],
  ];

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onPolylineTapped(PolylineId polylineId) {
    setState(() {
      selectedPolyline = polylineId;
    });
  }

  void _remove() {
    setState(() {
      if (polylines.containsKey(selectedPolyline)) {
        polylines.remove(selectedPolyline);
      }
      selectedPolyline = null;
    });
  }

  void _add() {
    final int polylineCount = polylines.length;

    if (polylineCount == 12) {
      return;
    }

    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.orange,
      width: 5,
      points: _createPoints(),
      onTap: () {
        _onPolylineTapped(polylineId);
      },
    );

    setState(() {
      polylines[polylineId] = polyline;
    });
  }

  void _toggleGeodesic() {
    final Polyline polyline = polylines[selectedPolyline];
    setState(() {
      polylines[selectedPolyline] = polyline.copyWith(
        geodesicParam: !polyline.geodesic,
      );
    });
  }

  void _toggleVisible() {
    final Polyline polyline = polylines[selectedPolyline];
    setState(() {
      polylines[selectedPolyline] = polyline.copyWith(
        visibleParam: !polyline.visible,
      );
    });
  }

  void _changeColor() {
    final Polyline polyline = polylines[selectedPolyline];
    setState(() {
      polylines[selectedPolyline] = polyline.copyWith(
        colorParam: colors[++colorsIndex % colors.length],
      );
    });
  }

  void _changeWidth() {
    final Polyline polyline = polylines[selectedPolyline];
    setState(() {
      polylines[selectedPolyline] = polyline.copyWith(
        widthParam: widths[++widthsIndex % widths.length],
      );
    });
  }

  void _changeJointType() {
    final Polyline polyline = polylines[selectedPolyline];
    setState(() {
      polylines[selectedPolyline] = polyline.copyWith(
        jointTypeParam: jointTypes[++jointTypesIndex % jointTypes.length],
      );
    });
  }

  void _changeEndCap() {
    final Polyline polyline = polylines[selectedPolyline];
    setState(() {
      polylines[selectedPolyline] = polyline.copyWith(
        endCapParam: endCaps[++endCapsIndex % endCaps.length],
      );
    });
  }

  void _changeStartCap() {
    final Polyline polyline = polylines[selectedPolyline];
    setState(() {
      polylines[selectedPolyline] = polyline.copyWith(
        startCapParam: startCaps[++startCapsIndex % startCaps.length],
      );
    });
  }

  void _changePattern() {
    final Polyline polyline = polylines[selectedPolyline];
    setState(() {
      polylines[selectedPolyline] = polyline.copyWith(
        patternsParam: patterns[++patternsIndex % patterns.length],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool iOSorNotSelected = Platform.isIOS || (selectedPolyline == null);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: SizedBox(
              width: 350.0,
              height: 300.0,
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(52.4478, -3.5402),
                  zoom: 7.0,
                ),
                polylines: Set<Polyline>.of(polylines.values),
                onMapCreated: _onMapCreated,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('add'),
                            onPressed: _add,
                          ),
                          FlatButton(
                            child: const Text('remove'),
                            onPressed:
                            (selectedPolyline == null) ? null : _remove,
                          ),
                          FlatButton(
                            child: const Text('toggle visible'),
                            onPressed: (selectedPolyline == null)
                                ? null
                                : _toggleVisible,
                          ),
                          FlatButton(
                            child: const Text('toggle geodesic'),
                            onPressed: (selectedPolyline == null)
                                ? null
                                : _toggleGeodesic,
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('change width'),
                            onPressed:
                            (selectedPolyline == null) ? null : _changeWidth,
                          ),
                          FlatButton(
                            child: const Text('change color'),
                            onPressed:
                            (selectedPolyline == null) ? null : _changeColor,
                          ),
                          FlatButton(
                            child: const Text('change start cap [Android only]'),
                            onPressed: iOSorNotSelected ? null : _changeStartCap,
                          ),
                          FlatButton(
                            child: const Text('change end cap [Android only]'),
                            onPressed: iOSorNotSelected ? null : _changeEndCap,
                          ),
                          FlatButton(
                            child: const Text('change joint type [Android only]'),
                            onPressed: iOSorNotSelected ? null : _changeJointType,
                          ),
                          FlatButton(
                            child: const Text('change pattern [Android only]'),
                            onPressed: iOSorNotSelected ? null : _changePattern,
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];
    final double offset = _polylineIdCounter.ceilToDouble();
    points.add(_createLatLng(51.4816 + offset, -3.1791));
    points.add(_createLatLng(53.0430 + offset, -2.9925));
    points.add(_createLatLng(53.1396 + offset, -4.2739));
    points.add(_createLatLng(52.4153 + offset, -4.0829));
    return points;
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }
}

class ScrollingMapBody extends StatelessWidget {
  const ScrollingMapBody();

  final LatLng center = const LatLng(32.080664, 34.9563837);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: Text('This map consumes all touch events.'),
                  ),
                  Center(
                    child: SizedBox(
                      width: 300.0,
                      height: 300.0,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: center,
                          zoom: 11.0,
                        ),
                        gestureRecognizers:
                        // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                        // https://github.com/flutter/flutter/issues/28312
                        // ignore: prefer_collection_literals
                        <Factory<OneSequenceGestureRecognizer>>[
                          Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer(),
                          ),
                        ].toSet(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Column(
                children: <Widget>[
                  const Text('This map doesn\'t consume the vertical drags.'),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child:
                    Text('It still gets other gestures (e.g scale or tap).'),
                  ),
                  Center(
                    child: SizedBox(
                      width: 300.0,
                      height: 300.0,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: center,
                          zoom: 11.0,
                        ),
                        markers:
                        // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                        // https://github.com/flutter/flutter/issues/28312
                        // ignore: prefer_collection_literals
                        Set<Marker>.of(
                          <Marker>[
                            Marker(
                              markerId: MarkerId("test_marker_id"),
                              position: LatLng(
                                center.latitude,
                                center.longitude,
                              ),
                              infoWindow: const InfoWindow(
                                title: 'An interesting location',
                                snippet: '*',
                              ),
                            )
                          ],
                        ),
                        gestureRecognizers:
                        // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                        // https://github.com/flutter/flutter/issues/28312
                        // ignore: prefer_collection_literals
                        <Factory<OneSequenceGestureRecognizer>>[
                          Factory<OneSequenceGestureRecognizer>(
                                () => ScaleGestureRecognizer(),
                          ),
                        ].toSet(),
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

class MapUiBody extends StatefulWidget {
  const MapUiBody();

  @override
  State<StatefulWidget> createState() => MapUiBodyState();
}

final LatLngBounds sydneyBounds = LatLngBounds(
  southwest: const LatLng(-34.022631, 150.620685),
  northeast: const LatLng(-33.571835, 151.325952),
);

class MapUiBodyState extends State<MapUiBody> {
  MapUiBodyState();

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(-33.852, 151.211),
    zoom: 11.0,
  );

  CameraPosition _position = _kInitialPosition;
  bool _isMapCreated = false;
  bool _isMoving = false;
  bool _compassEnabled = true;
  bool _mapToolbarEnabled = true;
  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  MapType _mapType = MapType.normal;
  bool _rotateGesturesEnabled = true;
  bool _scrollGesturesEnabled = true;
  bool _tiltGesturesEnabled = true;
  bool _zoomControlsEnabled = false;
  bool _zoomGesturesEnabled = true;
  bool _indoorViewEnabled = true;
  bool _myLocationEnabled = true;
  bool _myTrafficEnabled = false;
  bool _myLocationButtonEnabled = true;
  GoogleMapController _controller;
  bool _nightMode = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _compassToggler() {
    return FlatButton(
      child: Text('${_compassEnabled ? 'disable' : 'enable'} compass'),
      onPressed: () {
        setState(() {
          _compassEnabled = !_compassEnabled;
        });
      },
    );
  }

  Widget _mapToolbarToggler() {
    return FlatButton(
      child: Text('${_mapToolbarEnabled ? 'disable' : 'enable'} map toolbar'),
      onPressed: () {
        setState(() {
          _mapToolbarEnabled = !_mapToolbarEnabled;
        });
      },
    );
  }

  Widget _latLngBoundsToggler() {
    return FlatButton(
      child: Text(
        _cameraTargetBounds.bounds == null
            ? 'bound camera target'
            : 'release camera target',
      ),
      onPressed: () {
        setState(() {
          _cameraTargetBounds = _cameraTargetBounds.bounds == null
              ? CameraTargetBounds(sydneyBounds)
              : CameraTargetBounds.unbounded;
        });
      },
    );
  }

  Widget _zoomBoundsToggler() {
    return FlatButton(
      child: Text(_minMaxZoomPreference.minZoom == null
          ? 'bound zoom'
          : 'release zoom'),
      onPressed: () {
        setState(() {
          _minMaxZoomPreference = _minMaxZoomPreference.minZoom == null
              ? const MinMaxZoomPreference(12.0, 16.0)
              : MinMaxZoomPreference.unbounded;
        });
      },
    );
  }

  Widget _mapTypeCycler() {
    final MapType nextType =
    MapType.values[(_mapType.index + 1) % MapType.values.length];
    return FlatButton(
      child: Text('change map type to $nextType'),
      onPressed: () {
        setState(() {
          _mapType = nextType;
        });
      },
    );
  }

  Widget _rotateToggler() {
    return FlatButton(
      child: Text('${_rotateGesturesEnabled ? 'disable' : 'enable'} rotate'),
      onPressed: () {
        setState(() {
          _rotateGesturesEnabled = !_rotateGesturesEnabled;
        });
      },
    );
  }

  Widget _scrollToggler() {
    return FlatButton(
      child: Text('${_scrollGesturesEnabled ? 'disable' : 'enable'} scroll'),
      onPressed: () {
        setState(() {
          _scrollGesturesEnabled = !_scrollGesturesEnabled;
        });
      },
    );
  }

  Widget _tiltToggler() {
    return FlatButton(
      child: Text('${_tiltGesturesEnabled ? 'disable' : 'enable'} tilt'),
      onPressed: () {
        setState(() {
          _tiltGesturesEnabled = !_tiltGesturesEnabled;
        });
      },
    );
  }

  Widget _zoomToggler() {
    return FlatButton(
      child: Text('${_zoomGesturesEnabled ? 'disable' : 'enable'} zoom'),
      onPressed: () {
        setState(() {
          _zoomGesturesEnabled = !_zoomGesturesEnabled;
        });
      },
    );
  }

  Widget _zoomControlsToggler() {
    return FlatButton(
      child:
      Text('${_zoomControlsEnabled ? 'disable' : 'enable'} zoom controls'),
      onPressed: () {
        setState(() {
          _zoomControlsEnabled = !_zoomControlsEnabled;
        });
      },
    );
  }

  Widget _indoorViewToggler() {
    return FlatButton(
      child: Text('${_indoorViewEnabled ? 'disable' : 'enable'} indoor'),
      onPressed: () {
        setState(() {
          _indoorViewEnabled = !_indoorViewEnabled;
        });
      },
    );
  }

  Widget _myLocationToggler() {
    return FlatButton(
      child: Text(
          '${_myLocationButtonEnabled ? 'disable' : 'enable'} my location button'),
      onPressed: () {
        setState(() {
          _myLocationEnabled = !_myLocationEnabled;
        });
      },
    );
  }

  Widget _myLocationButtonToggler() {
    return FlatButton(
      child: Text(
          '${_myLocationButtonEnabled ? 'disable' : 'enable'} my location button'),
      onPressed: () {
        setState(() {
          _myLocationButtonEnabled = !_myLocationButtonEnabled;
        });
      },
    );
  }

  Widget _myTrafficToggler() {
    return FlatButton(
      child: Text('${_myTrafficEnabled ? 'disable' : 'enable'} my traffic'),
      onPressed: () {
        setState(() {
          _myTrafficEnabled = !_myTrafficEnabled;
        });
      },
    );
  }

  Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void _setMapStyle(String mapStyle) {
    setState(() {
      _nightMode = true;
      _controller.setMapStyle(mapStyle);
    });
  }

  Widget _nightModeToggler() {
    if (!_isMapCreated) {
      return null;
    }
    return FlatButton(
      child: Text('${_nightMode ? 'disable' : 'enable'} night mode'),
      onPressed: () {
        if (_nightMode) {
          setState(() {
            _nightMode = false;
            _controller.setMapStyle(null);
          });
        } else {
          _getFileData('assets/night_mode.json').then(_setMapStyle);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final GoogleMap googleMap = GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
      compassEnabled: _compassEnabled,
      mapToolbarEnabled: _mapToolbarEnabled,
      cameraTargetBounds: _cameraTargetBounds,
      minMaxZoomPreference: _minMaxZoomPreference,
      mapType: _mapType,
      rotateGesturesEnabled: _rotateGesturesEnabled,
      scrollGesturesEnabled: _scrollGesturesEnabled,
      tiltGesturesEnabled: _tiltGesturesEnabled,
      zoomGesturesEnabled: _zoomGesturesEnabled,
      zoomControlsEnabled: _zoomControlsEnabled,
      indoorViewEnabled: _indoorViewEnabled,
      myLocationEnabled: _myLocationEnabled,
      myLocationButtonEnabled: _myLocationButtonEnabled,
      trafficEnabled: _myTrafficEnabled,
      onCameraMove: _updateCameraPosition,
    );

    final List<Widget> columnChildren = <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SizedBox(
            width: 300.0,
            height: 200.0,
            child: googleMap,
          ),
        ),
      ),
    ];

    if (_isMapCreated) {
      columnChildren.add(
        Expanded(
          child: ListView(
            children: <Widget>[
              Text('camera bearing: ${_position.bearing}'),
              Text(
                  'camera target: ${_position.target.latitude.toStringAsFixed(4)},'
                      '${_position.target.longitude.toStringAsFixed(4)}'),
              Text('camera zoom: ${_position.zoom}'),
              Text('camera tilt: ${_position.tilt}'),
              Text(_isMoving ? '(Camera moving)' : '(Camera idle)'),
              _compassToggler(),
              _mapToolbarToggler(),
              _latLngBoundsToggler(),
              _mapTypeCycler(),
              _zoomBoundsToggler(),
              _rotateToggler(),
              _scrollToggler(),
              _tiltToggler(),
              _zoomToggler(),
              _zoomControlsToggler(),
              _indoorViewToggler(),
              _myLocationToggler(),
              _myLocationButtonToggler(),
              _myTrafficToggler(),
              _nightModeToggler(),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: columnChildren,
      ),
    );
  }

  void _updateCameraPosition(CameraPosition position) {
    setState(() {
      _position = position;
    });
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
      _isMapCreated = true;
    });
  }
}