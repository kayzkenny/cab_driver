import 'dart:async';

import 'package:cab_driver/models/trip_details.dart';
import 'package:cab_driver/shared/global_variables.dart';
import 'package:cab_driver/widgets/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging();

  Future<void> initialize(BuildContext context) async {
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        await fetchRideInfo(
          getRideID(message),
          context,
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        await fetchRideInfo(
          getRideID(message),
          context,
        );
      },
      onResume: (Map<String, dynamic> message) async {
        await fetchRideInfo(
          getRideID(message),
          context,
        );
      },
    );
  }

  Future<void> getToken() async {
    String token = await fcm.getToken();
    print('token: $token');

    DatabaseReference tokenRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentFirebaseUser.uid}/token');
    tokenRef.set(token);

    fcm.subscribeToTopic('alldrivers');
    fcm.subscribeToTopic('allusers');
  }

  String getRideID(Map<String, dynamic> message) {
    print("onResume: $message");

    var data = message['data'] ?? message;
    String rideID = data['ride_id'];
    print('ride_id: $rideID');

    return rideID;
  }

  Future<void> fetchRideInfo(String rideID, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProgressDialog(
        status: 'Fetching details...',
      ),
    );

    DatabaseReference rideRef =
        FirebaseDatabase.instance.reference().child('rideRequest/$rideID');

    DataSnapshot snapshot = await rideRef.once();

    if (snapshot.value != null) {
      double pickupLat = double.parse(
        snapshot.value['location']['latitude'].toString(),
      );
      double pickupLng = double.parse(
        snapshot.value['location']['longitude'].toString(),
      );
      String pickupAddress = snapshot.value['pickup_address'].toString();
      double destinationLat = double.parse(
        snapshot.value['destination']['latitude'].toString(),
      );
      double destinationLng = double.parse(
        snapshot.value['destination']['longitude'].toString(),
      );
      String destinationAddress = snapshot.value['destination_address'];
      String paymentMethod = snapshot.value['payment_method'];

      TripDetails tripDetails = TripDetails(
        rideID: rideID,
        paymentMethod: paymentMethod,
        pickupAddress: pickupAddress,
        destinationAddress: destinationAddress,
        pickup: LatLng(pickupLat, pickupLng),
        destination: LatLng(destinationLat, destinationLng),
      );

      print(tripDetails.destinationAddress);
    }

    Navigator.pop(context);
  }
}
