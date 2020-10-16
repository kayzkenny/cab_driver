import 'package:flutter/material.dart';
import 'package:cab_driver/widgets/taxi_button.dart';
import 'package:cab_driver/screens/brand_colors.dart';
import 'package:cab_driver/widgets/taxi_outline_button.dart';

class ConfirmSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onPressed;

  const ConfirmSheet({
    this.title,
    this.subtitle,
    this.onPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15.0,
            spreadRadius: 0.5,
            offset: Offset(0.7, 0.7),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'Brand-Bold',
              color: BrandColors.colorText,
            ),
          ),
          Container(
            width: 300,
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: BrandColors.colorTextLight,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TaxiOutlineButton(
                title: 'BACK',
                color: BrandColors.colorLightGrayFair,
                onPressed: () => Navigator.pop(context),
              ),
              TaxiButton(
                title: 'CONFIRM',
                color: (title == 'GO ONLINE')
                    ? BrandColors.colorGreen
                    : Colors.red,
                onPressed: onPressed,
              ),
            ],
          )
        ],
      ),
    );
  }
}
