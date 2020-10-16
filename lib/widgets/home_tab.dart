import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cab_driver/widgets/taxi_button.dart';
import 'package:cab_driver/screens/brand_colors.dart';
import 'package:cab_driver/helpers/helper_methods.dart';
import 'package:cab_driver/widgets/global_vehicles.dart';
import 'package:cab_driver/widgets/availability_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  Position currentPosition;
  double mapTopPadding = 135;

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

    String address = await HelperMethods.findCoordinateAddress(
      position,
      context,
    );
    print(address);
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
              title: 'GO ONLINE',
              color: BrandColors.colorOrange,
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }
}
