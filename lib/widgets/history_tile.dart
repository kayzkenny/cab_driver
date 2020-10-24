import 'package:flutter/material.dart';
import 'package:cab_driver/models/history.dart';
import 'package:cab_driver/screens/brand_colors.dart';
import 'package:cab_driver/helpers/helper_methods.dart';

class HistoryTile extends StatelessWidget {
  final History history;
  const HistoryTile({
    this.history,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Image.asset(
                  'images/pickicon.png',
                  height: 16,
                  width: 16,
                ),
                SizedBox(width: 18),
                Expanded(
                  child: Container(
                    child: Text(
                      history.pickup,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '\$${history.fares}',
                  style: TextStyle(
                      fontFamily: 'Brand-Bold',
                      fontSize: 16,
                      color: BrandColors.colorPrimary),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Image.asset(
                'images/desticon.png',
                height: 16,
                width: 16,
              ),
              SizedBox(width: 18),
              Text(
                history.destination,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            HelperMethods.formatMyDate(history.createdAt),
            style: TextStyle(color: BrandColors.colorTextLight),
          ),
        ],
      ),
    );
  }
}
