import 'package:flutter/material.dart';
import 'package:cab_driver/screens/brand_colors.dart';

class TaxiOutlineButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color color;

  const TaxiOutlineButton({
    this.title,
    this.onPressed,
    this.color,
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      borderSide: BorderSide(color: color),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      onPressed: onPressed,
      color: color,
      child: Container(
        height: 50.0,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: 'Brand-Bold',
              color: BrandColors.colorText,
            ),
          ),
        ),
      ),
    );
  }
}
