import 'package:flutter/material.dart';
import 'package:cab_driver/models/driver.dart';
import 'package:cab_driver/screens/login_page.dart';
import 'package:cab_driver/widgets/taxi_button.dart';
import 'package:cab_driver/screens/brand_colors.dart';
import 'package:cab_driver/shared/global_variables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _formKey = GlobalKey<FormState>();
  final _auth = auth.FirebaseAuth.instance;

  // form values
  String _currentFullName = currentDriverInfo.fullName;
  String _currentCarModel = currentDriverInfo.carModel;
  String _currentPhoneNumber = currentDriverInfo.phone;
  String _currentCarColor = currentDriverInfo.carColor;
  String _currentVehicleNumber = currentDriverInfo.vehicleNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Your Profile',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28.0),
              ),
              SizedBox(height: 40.0),
              TextFormField(
                initialValue: currentDriverInfo.fullName,
                decoration: InputDecoration(
                  hintText: 'Full Name',
                  labelText: 'FirstName',
                ),
                validator: (value) => value.isEmpty ? 'First Name' : null,
                onChanged: (value) => setState(() => _currentFullName = value),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                initialValue: currentDriverInfo.phone,
                decoration: InputDecoration(
                  hintText: 'Phone',
                  labelText: 'Phone',
                ),
                validator: (value) => value.isEmpty ? 'Phone' : null,
                onChanged: (value) =>
                    setState(() => _currentPhoneNumber = value),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                initialValue: currentDriverInfo.carModel,
                decoration: InputDecoration(
                  hintText: 'Car Model',
                  labelText: 'Car Model',
                ),
                validator: (value) => value.isEmpty ? 'Car Model' : null,
                onChanged: (value) => setState(() => _currentCarModel = value),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                initialValue: currentDriverInfo.carColor,
                decoration: InputDecoration(
                  hintText: 'Car Color',
                  labelText: 'Car Color',
                ),
                validator: (value) => value.isEmpty ? 'Car Color' : null,
                onChanged: (value) => setState(() => _currentCarModel = value),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                initialValue: currentDriverInfo.vehicleNumber,
                decoration: InputDecoration(
                  hintText: 'Car Number',
                  labelText: 'Car Number',
                ),
                validator: (value) => value.isEmpty ? 'Car Number' : null,
                onChanged: (value) =>
                    setState(() => _currentVehicleNumber = value),
              ),
              SizedBox(height: 40.0),
              TaxiButton(
                color: BrandColors.colorAccentPurple,
                title: 'UPDATE',
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    final dbRef = FirebaseDatabase.instance.reference();
                    final fullNameRef = dbRef
                        .child('drivers/${currentFirebaseUser.uid}/fullname');
                    final phoneRef =
                        dbRef.child('drivers/${currentFirebaseUser.uid}/phone');
                    final carColorRef = dbRef.child(
                        'drivers/${currentFirebaseUser.uid}/vehicle_details/car_color');
                    final carModelRef = dbRef.child(
                        'drivers/${currentFirebaseUser.uid}/vehicle_details/car_model');
                    final vehicleNumberRef = dbRef.child(
                        'drivers/${currentFirebaseUser.uid}/vehicle_details/vehicle_number');

                    await fullNameRef.set(_currentFullName);
                    await phoneRef.set(_currentPhoneNumber);
                    await carColorRef.set(_currentCarColor);
                    await carModelRef.set(_currentCarModel);
                    await vehicleNumberRef.set(_currentVehicleNumber);

                    final driverRef =
                        dbRef.child('drivers/${currentFirebaseUser.uid}');

                    DataSnapshot snapshot = await driverRef.once();

                    if (snapshot.value != null) {
                      currentDriverInfo = Driver.fromSnapshot(snapshot);
                    }
                  }
                },
              ),
              SizedBox(height: 30.0),
              TaxiButton(
                color: BrandColors.colorOrange,
                title: 'LOGOUT',
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pushReplacementNamed(
                    context,
                    LoginPage.id,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
