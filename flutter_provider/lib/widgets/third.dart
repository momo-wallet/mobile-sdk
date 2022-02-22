import 'package:flutter/material.dart';
import 'package:flutter_provider/model/location.dart';
import 'package:provider/provider.dart';

class ThirdStreamWidget extends StatelessWidget {
  const ThirdStreamWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var allWonders = Provider.of<List<LocationModelAdvanced>>(context);

    print('\n Inside third Widget..');

    return Container(
      color: Colors.red,
      child: Column(

    //    children: [for (var wonder in allWonders) Text(wonder.name)],
      ),
    );
  }
}
