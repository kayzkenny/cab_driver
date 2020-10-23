import 'package:flutter/material.dart';
import 'package:cab_driver/models/trip_details.dart';
import 'package:cab_driver/widgets/taxi_button.dart';
import 'package:cab_driver/screens/brand_colors.dart';
import 'package:cab_driver/screens/new_trip_page.dart';
import 'package:cab_driver/widgets/brand_divider.dart';
import 'package:cab_driver/helpers/helper_methods.dart';
import 'package:cab_driver/shared/global_variables.dart';
import 'package:cab_driver/widgets/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cab_driver/widgets/taxi_outline_button.dart';

class NotificationDialog extends StatelessWidget {
  final TripDetails tripDetails;

  const NotificationDialog({
    this.tripDetails,
    Key key,
  }) : super(key: key);

  // TODO: Use when ScaffoldMessenger is avaliable on the stable channel
  // void showSnackbar({BuildContext context, String content}) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(content),
  //     ),
  //   );
  // }

  Future<void> checkAvailability(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProgressDialog(
        status: 'Accepting request...',
      ),
    );

    DatabaseReference newRideRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentFirebaseUser.uid}/newtrip');

    String thisRideID = "";
    DataSnapshot snapshot = await newRideRef.once();

    Navigator.pop(context);

    snapshot.value != null
        ? thisRideID = snapshot.value.toString()
        : print("Ride not found");
    // showSnackbar(context: context, content: "Ride not found");

    if (thisRideID == tripDetails.rideID) {
      await newRideRef.set('accepted');
      await HelperMethods.disableHomeTabLocationUpdates();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewTripPage(tripDetails: tripDetails),
        ),
      );
    } else if (thisRideID == 'cancelled') {
      // showSnackbar(context: context, content: "Ride Cancelled");
    } else if (thisRideID == 'timeout') {
      // showSnackbar(context: context, content: "Request timed out");
    } else {
      // showSnackbar(context: context, content: "Ride not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        height: 400,
        margin: EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'images/taxi.png',
              width: 100,
            ),
            Text(
              'NEW TRIP REQUEST',
              style: TextStyle(
                fontFamily: 'Brand-Bold',
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 32.0,
                right: 32.0,
                bottom: 16.0,
                top: 32.0,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'images/pickicon.png',
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Container(
                          child: Text(
                            tripDetails.pickupAddress,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'images/desticon.png',
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Container(
                          child: Text(
                            tripDetails.destinationAddress,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            BrandDivider(height: 0.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TaxiOutlineButton(
                  title: 'DECLINE',
                  color: BrandColors.colorPrimary,
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
                TaxiButton(
                  title: 'ACCEPT',
                  color: BrandColors.colorGreen,
                  onPressed: () async {
                    Navigator.pop(context);
                    await checkAvailability(context);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
