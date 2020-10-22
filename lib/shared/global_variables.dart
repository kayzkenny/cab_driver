import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:cab_driver/models/user.dart';
import 'package:cab_driver/models/driver.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_maps_flutter/google_maps_flutter.dart';

String googleMapsEndpoint = 'https://maps.googleapis.com/maps/api';
String geocodeEndpoint = '$googleMapsEndpoint/geocode/json';
String placesEndpoint = '$googleMapsEndpoint/place/autocomplete/json';
String placeDetailsEndpoint = '$googleMapsEndpoint/place/details/json';
String directionsEndpoint = '$googleMapsEndpoint/directions/json';

User currentUserInfo;
Driver currentDriverInfo;
Position currentPosition;
DatabaseReference rideRef;
auth.User currentFirebaseUser;
StreamSubscription<Position> ridePositionStream;
StreamSubscription<Position> homeTabPositionStream;

final player = AudioCache(prefix: 'sounds/');
final CameraPosition googlePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);
