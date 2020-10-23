import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cab_driver/shared/api_keys.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:cab_driver/helpers/request_helper.dart';
import 'package:cab_driver/shared/global_variables.dart';
import 'package:cab_driver/widgets/progress_dialog.dart';
import 'package:cab_driver/models/direction_details.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HelperMethods {
  static Future<DirectionDetails> getDirectionDetails(
    LatLng startPosition,
    LatLng endPosition,
  ) async {
    String url =
        '$directionsEndpoint?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$googleMapsKey';
    var response = await RequestHelper.getRequest(url);

    if (response == 'failed') {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails(
      durationText: response['routes'][0]['legs'][0]['duration']['text'],
      durationValue: response['routes'][0]['legs'][0]['duration']['value'],
      distanceText: response['routes'][0]['legs'][0]['distance']['text'],
      distanceValue: response['routes'][0]['legs'][0]['distance']['value'],
      encodedPoints: response['routes'][0]['overview_polyline']['points'],
    );

    return directionDetails;
  }

  static int estimateFares(DirectionDetails details, int durationValue) {
    // per km = $0.3, per min = $0.2, base fare = $3,
    double baseFare = 3;
    double timeFare = (durationValue / 60) * 0.2;
    double distanceFare = (details.distanceValue / 1000) * 0.3;
    double totalFare = baseFare + distanceFare + timeFare;

    return totalFare.truncate();
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);

    return randInt.toDouble();
  }

  static Future<void> disableHomeTabLocationUpdates() async {
    homeTabPositionStream.pause();
    await Geofire.removeLocation(currentFirebaseUser.uid);
  }

  static Future<void> enableHomeTabLocationUpdates() async {
    homeTabPositionStream.resume();
    await Geofire.setLocation(
      currentFirebaseUser.uid,
      currentPosition.latitude,
      currentPosition.longitude,
    );
  }

  static void showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Please wait',
      ),
    );
  }
}
