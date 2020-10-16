import 'package:flutter/material.dart';
import 'package:cab_driver/screens/main_page.dart';
import 'package:cab_driver/widgets/taxi_button.dart';
import 'package:cab_driver/screens/brand_colors.dart';
import 'package:cab_driver/widgets/global_vehicles.dart';
import 'package:firebase_database/firebase_database.dart';

class VehicleInfoPage extends StatelessWidget {
  static const String id = 'vehicleinfo';

  final formKey = GlobalKey<FormState>();
  final carModelController = TextEditingController();
  final carColorController = TextEditingController();
  final vehicleNumberController = TextEditingController();

  Future<void> updateProfile() async {
    String id = currentFirebaseUser.uid;
    DatabaseReference driveRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/$id/vehicle_details');
    Map map = {
      'car_color': carColorController.text.trim(),
      'car_model': carModelController.text.trim(),
      'vehicle_number': vehicleNumberController.text.trim(),
    };
    await driveRef.set(map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                Image.asset(
                  'images/logo.png',
                  height: 110,
                  width: 110,
                ),
                SizedBox(height: 40),
                Text(
                  'Enter vehicle details',
                  style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 22),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: carModelController,
                  validator: (value) => value.length < 3
                      ? 'Enter a car model name at least 3 characters long'
                      : null,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Car Model',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: carColorController,
                  validator: (value) => value.length < 3
                      ? 'Enter a color at least 3 characters long'
                      : null,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Car Color',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: vehicleNumberController,
                  validator: (value) => value.length < 3
                      ? 'Enter a vehicle number at least 3 characters long'
                      : null,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Vehicle Number',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(height: 40),
                TaxiButton(
                  color: BrandColors.colorGreen,
                  title: 'PROCEED',
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      await updateProfile();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        MainPage.id,
                        (route) => false,
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
