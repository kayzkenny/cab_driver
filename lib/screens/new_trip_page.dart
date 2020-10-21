import 'package:flutter/material.dart';
import 'package:cab_driver/models/trip_details.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Trip'),
        centerTitle: true,
      ),
    );
  }
}
