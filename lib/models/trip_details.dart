import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetails {
  String rideID;
  String riderName;
  String riderPhone;
  String pickupAddress;
  String paymentMethod;
  String destinationAddress;
  LatLng pickup;
  LatLng destination;

  TripDetails({
    this.rideID,
    this.riderName,
    this.riderPhone,
    this.pickupAddress,
    this.paymentMethod,
    this.destinationAddress,
    this.pickup,
    this.destination,
  });
}
