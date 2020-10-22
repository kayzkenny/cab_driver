import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cab_driver/models/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cab_driver/screens/brand_colors.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:cab_driver/widgets/confirm_sheet.dart';
import 'package:cab_driver/shared/global_variables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cab_driver/widgets/availability_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cab_driver/helpers/push_notification_service.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  double mapTopPadding = 135;
  DatabaseReference tripRequestRef;
  String availabilityTitle = 'GO ONLINE';
  Color availabilityColor = BrandColors.colorOrange;
  bool isAvailable = false;

  final geolocator = GeolocatorPlatform.instance;
  final locationOptions = LocationOptions(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 4,
  );

  Future<void> setupPositionLocator() async {
    Position position = await getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    currentPosition = position;

    LatLng pos = LatLng(
      position.latitude,
      position.longitude,
    );

    CameraPosition cp = CameraPosition(
      target: pos,
      zoom: 14,
    );

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(cp),
    );
  }

  Future<void> goOnline() async {
    await Geofire.initialize('driversAvailable');
    await Geofire.setLocation(
      currentFirebaseUser.uid,
      currentPosition.latitude,
      currentPosition.longitude,
    );

    tripRequestRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentFirebaseUser.uid}/newtrip');

    await tripRequestRef.set('waiting');

    tripRequestRef.onValue.listen((event) {});
  }

  Future<void> goOffline() async {
    await Geofire.removeLocation(currentFirebaseUser.uid);
    tripRequestRef.onDisconnect();
    await tripRequestRef.remove();
    tripRequestRef = null;
  }

  Future<void> getCurrentDriverInfo() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    DatabaseReference driverRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentFirebaseUser.uid}');

    DataSnapshot snapshot = await driverRef.once();
    if (snapshot.value != null) {
      currentDriverInfo = Driver.fromSnapshot(snapshot);
    }

    PushNotificationService pushNotificationService = PushNotificationService();
    await pushNotificationService.initialize(context);
    await pushNotificationService.getToken();
  }

  void getlocationUpdates() {
    homeTabPositionStream = geolocator
        .getPositionStream(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 4,
    )
        .listen((Position position) {
      currentPosition = position;

      if (isAvailable) {
        Geofire.setLocation(
          currentFirebaseUser.uid,
          position.latitude,
          position.longitude,
        );
      }

      LatLng pos = LatLng(
        position.latitude,
        position.longitude,
      );
      CameraPosition cp = CameraPosition(
        target: pos,
        zoom: 14,
      );
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(cp),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentDriverInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Google Map
        GoogleMap(
          // markers: _markers,
          // circles: _circles,
          // polylines: _polylines,
          mapType: MapType.normal,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          myLocationButtonEnabled: true,
          initialCameraPosition: googlePlex,
          padding: EdgeInsets.only(top: mapTopPadding),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            mapController = controller;
            // setState(() => mapBottomPadding = 300);
            setupPositionLocator();
          },
        ),
        Container(
          height: mapTopPadding,
          width: double.infinity,
          color: BrandColors.colorPrimary,
          child: Center(
            child: AvailabilityButton(
              title: availabilityTitle,
              color: availabilityColor,
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  builder: (context) => ConfirmSheet(
                    title: (!isAvailable) ? 'GO ONLINE' : 'GO OFFLINE',
                    subtitle: (!isAvailable)
                        ? 'You are about to become available to receive trip requests'
                        : 'You will stop receiving new trip requests',
                    onPressed: (!isAvailable)
                        ? () async {
                            await goOnline();
                            getlocationUpdates();
                            Navigator.pop(context);

                            setState(() {
                              availabilityColor = BrandColors.colorGreen;
                              availabilityTitle = 'GO OFFLINE';
                              isAvailable = true;
                            });
                          }
                        : () async {
                            await goOffline();
                            Navigator.pop(context);

                            setState(() {
                              availabilityColor = BrandColors.colorOrange;
                              availabilityTitle = 'GO ONLINE';
                              isAvailable = false;
                            });
                          },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
