import 'package:flutter/material.dart';
import 'package:cab_driver/screens/brand_colors.dart';
import 'package:cab_driver/widgets/brand_divider.dart';

class EarningsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: BrandColors.colorPrimary,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 70.0),
            child: Column(
              children: [
                Text(
                  'Total Earnings',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  '\$10',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontFamily: 'Brand-Bold',
                  ),
                ),
              ],
            ),
          ),
        ),
        FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
          onPressed: () {},
          child: Row(
            children: [
              Image.asset(
                'images/taxi.png',
                width: 70,
              ),
              SizedBox(width: 16),
              Text(
                'Trips',
                style: TextStyle(fontSize: 16),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    '3',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
        BrandDivider(height: 0),
      ],
    );
  }
}
