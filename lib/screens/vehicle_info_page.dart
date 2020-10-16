import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cab_driver/widgets/taxi_button.dart';
import 'package:cab_driver/screens/brand_colors.dart';

class VehicleInfoPage extends StatelessWidget {
  static const String id = 'vehicleinfo';

  final formKey = GlobalKey<FormState>();
  final carModelController = TextEditingController();
  final carColorController = TextEditingController();
  final vehicleNumberController = TextEditingController();

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
                  onPressed: () {
                    if (formKey.currentState.validate()) {}
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
