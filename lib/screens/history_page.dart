import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cab_driver/providers/app_data.dart';
import 'package:cab_driver/screens/brand_colors.dart';
import 'package:cab_driver/widgets/history_tile.dart';
import 'package:cab_driver/widgets/brand_divider.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip History'),
        backgroundColor: BrandColors.colorPrimary,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.only(top: 32),
        itemBuilder: (context, index) {
          return HistoryTile(
            history: Provider.of<AppData>(context).tripHistory[index],
          );
        },
        separatorBuilder: (BuildContext context, int index) => BrandDivider(
          indent: 32,
        ),
        itemCount: Provider.of<AppData>(context).tripHistory.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}
