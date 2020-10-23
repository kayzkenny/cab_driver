import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cab_driver/widgets/taxi_button.dart';
import 'package:cab_driver/models/trip_details.dart';
import 'package:cab_driver/screens/brand_colors.dart';
import 'package:cab_driver/helpers/mapkit_helper.dart';
import 'package:cab_driver/helpers/helper_methods.dart';
import 'package:cab_driver/widgets/progress_dialog.dart';
import 'package:cab_driver/shared/global_variables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class NewTripPage extends StatefulWidget {
  final TripDetails tripDetails;
  const NewTripPage({
    this.tripDetails,
    Key key,
  }) : super(key: key);

  @override
  _NewTripPageState createState() => _NewTripPageState();
}

class _NewTripPageState extends State<NewTripPage> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController rideMapController;
  Set<Marker> _markers = Set<Marker>();
  Set<Circle> _circles = Set<Circle>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double mapBottomPadding = 0;
  BitmapDescriptor movingMarkerIcon;
  Position myPosition;
  String status = 'accepted';
  String durationString = "";
  String buttonTitle = 'ARRIVED';
  bool isRequestingDirection = false;
  Color buttonColor = BrandColors.colorGreen;
  Timer timer;
  int durationCounter = 0;

  // final geolocator = getCurrentPosition();
  final locationOptions =
      LocationOptions(accuracy: LocationAccuracy.bestForNavigation);

  Future<void> updateTripDetails() async {
    if (!isRequestingDirection) {
      isRequestingDirection = true;

      if (myPosition == null) {
        return;
      }

      var positionLatLng = LatLng(myPosition.latitude, myPosition.longitude);
      LatLng destinationLatLng;

      destinationLatLng = status == 'accepted'
          ? widget.tripDetails.pickup
          : widget.tripDetails.destination;

      var directionDetails = await HelperMethods.getDirectionDetails(
        positionLatLng,
        destinationLatLng,
      );

      if (directionDetails != null) {
        setState(() {
          durationString = directionDetails.durationText;
        });
      }
    }
    isRequestingDirection = false;
  }

  Future<void> createMarker() async {
    if (movingMarkerIcon == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(
        context,
        size: Size(2, 2),
      );

      movingMarkerIcon = await BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        (Platform.isIOS) ? 'images/car_ios.png' : 'images/car_android.png',
      );
    }
  }

  Future<void> acceptTrip() async {
    String rideID = widget.tripDetails.rideID;
    Map locationMap = {
      'latitude': currentPosition.latitude.toString(),
      'longitude': currentPosition.longitude.toString(),
    };
    rideRef =
        FirebaseDatabase.instance.reference().child('rideRequest/$rideID');

    await rideRef.child('status').set('accepted');
    await rideRef.child('driver_location').set(locationMap);
    await rideRef.child('driver_id').set(currentDriverInfo.id);
    await rideRef.child('driver_phone').set(currentDriverInfo.phone);
    await rideRef.child('driver_name').set(currentDriverInfo.fullName);
    await rideRef
        .child('car_details')
        .set('${currentDriverInfo.carColor} - ${currentDriverInfo.carModel}');
  }

  Future<void> getDirection(
    LatLng pickupLatLng,
    LatLng destinationLatLng,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProgressDialog(status: 'Please wait...'),
    );

    var thisDetails = await HelperMethods.getDirectionDetails(
      pickupLatLng,
      destinationLatLng,
    );

    Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results = polylinePoints.decodePolyline(
      thisDetails.encodedPoints,
    );

    polylineCoordinates.clear();

    if (results.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      results.forEach((point) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      });
    }

    _polylines.clear();

    Polyline polyline = Polyline(
      polylineId: PolylineId('polyid'),
      color: Color.fromARGB(255, 95, 109, 237),
      points: polylineCoordinates,
      jointType: JointType.round,
      width: 4,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );

    setState(() => _polylines.add(polyline));

    // make polyline fit inside the map
    LatLngBounds bounds;

    if (pickupLatLng.latitude > destinationLatLng.latitude &&
        pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
        southwest: destinationLatLng,
        northeast: pickupLatLng,
      );
    } else if (pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(
          pickupLatLng.latitude,
          destinationLatLng.longitude,
        ),
        northeast: LatLng(
          destinationLatLng.latitude,
          pickupLatLng.longitude,
        ),
      );
    } else if (pickupLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(
          destinationLatLng.latitude,
          pickupLatLng.longitude,
        ),
        northeast: LatLng(
          pickupLatLng.latitude,
          destinationLatLng.longitude,
        ),
      );
    } else {
      bounds = LatLngBounds(
        southwest: pickupLatLng,
        northeast: destinationLatLng,
      );
    }

    rideMapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 70),
    );

    Marker pickupMarker = Marker(
      position: pickupLatLng,
      markerId: MarkerId('pickup'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      position: destinationLatLng,
      markerId: MarkerId('destination'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _markers.add(pickupMarker);
      _markers.add(destinationMarker);
    });

    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: BrandColors.colorGreen,
      strokeWidth: 3,
      radius: 12,
      center: pickupLatLng,
      fillColor: BrandColors.colorGreen,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: BrandColors.colorAccentPurple,
      strokeWidth: 3,
      radius: 12,
      center: pickupLatLng,
      fillColor: BrandColors.colorAccentPurple,
    );

    setState(() {
      _circles.add(pickupCircle);
      _circles.add(destinationCircle);
    });
  }

  void getLocationUpdates() {
    LatLng oldPosition = LatLng(0, 0);

    ridePositionStream = getPositionStream(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    ).listen((Position position) async {
      myPosition = position;
      currentPosition = position;
      LatLng pos = LatLng(position.latitude, position.longitude);

      var rotation = MapKitHelper.getMarkerRotation(
        oldPosition.latitude,
        oldPosition.longitude,
        pos.latitude,
        pos.longitude,
      );

      Marker movingMaker = Marker(
        position: pos,
        rotation: rotation,
        icon: movingMarkerIcon,
        markerId: MarkerId('moving'),
        infoWindow: InfoWindow(title: 'Current Location'),
      );

      setState(() {
        CameraPosition cp = CameraPosition(
          target: pos,
          zoom: 17,
        );

        rideMapController.animateCamera(
          CameraUpdate.newCameraPosition(cp),
        );

        _markers.removeWhere((marker) => marker.markerId.value == 'moving');
        _markers.add(movingMaker);
      });
      oldPosition = pos;

      await updateTripDetails();

      Map locationMap = {
        'latitude': myPosition.latitude.toString(),
        'longitude': myPosition.longitude.toString(),
      };

      await rideRef.child('driver_location').set(locationMap);
    });
  }

  void startTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter++;
    });
  }

  @override
  void initState() {
    super.initState();
    acceptTrip();
  }

  @override
  Widget build(BuildContext context) {
    createMarker();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            /// Google Map
            GoogleMap(
              markers: _markers,
              circles: _circles,
              polylines: _polylines,
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: googlePlex,
              padding: EdgeInsets.only(bottom: mapBottomPadding),
              onMapCreated: (GoogleMapController controller) async {
                _controller.complete(controller);
                rideMapController = controller;
                setState(() => mapBottomPadding = 300);
                var currentLatLng = LatLng(
                  currentPosition.latitude,
                  currentPosition.longitude,
                );
                var pickupLatLng = widget.tripDetails.pickup;
                await getDirection(currentLatLng, pickupLatLng);
                getLocationUpdates();
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(32),
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      durationString,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Brand-Bold',
                        color: BrandColors.colorAccentPurple,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daniel Jones',
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Brand-Bold',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.call),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'images/pickicon.png',
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(width: 18),
                        Expanded(
                          child: Container(
                            child: Text(
                              'NTSC RD, Alakahia Nigeria',
                              style: TextStyle(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'images/desticon.png',
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(width: 18),
                        Expanded(
                          child: Container(
                            child: Text(
                              'SPAR PH',
                              style: TextStyle(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TaxiButton(
                      title: buttonTitle,
                      color: buttonColor,
                      onPressed: () async {
                        if (status == 'accepted') {
                          status = 'arrived';
                          await rideRef.child('status').set('arrived');

                          setState(() {
                            buttonTitle = 'START TRIP';
                            buttonColor = BrandColors.colorAccentPurple;
                          });

                          HelperMethods.showProgressDialog(context);

                          await getDirection(
                            widget.tripDetails.pickup,
                            widget.tripDetails.destination,
                          );

                          Navigator.pop(context);
                        } else if (status == 'arrived') {
                          status = 'ontrip';
                          await rideRef.child('status').set('ontrip');

                          setState(() {
                            buttonTitle = 'END TRIP';
                            buttonColor = Colors.red[900];
                          });

                          startTimer();
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
