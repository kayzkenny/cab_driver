import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cab_driver/models/address.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cab_driver/shared/api_keys.dart';
import 'package:cab_driver/providers/app_data.dart';
import 'package:cab_driver/helpers/request_helper.dart';
import 'package:cab_driver/widgets/global_vehicles.dart';

class HelperMethods {
  static Future<String> findCoordinateAddress(
    Position position,
    BuildContext context,
  ) async {
    String placeAddress = "";

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }

    String url =
        '$geocodeEndpoint?latlng=${position.latitude},${position.longitude}&key=$googleMapsKey';

    var response = await RequestHelper.getRequest(url);

    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];

      // Address pickupAddress = new Address(
      //   latitude: position.latitude,
      //   longitude: position.longitude,
      //   placeName: placeAddress,
      // );

      // Provider.of<AppData>(
      //   context,
      //   listen: false,
      // ).updatePickupAddress(pickupAddress);
    }

    return placeAddress;
  }
}
