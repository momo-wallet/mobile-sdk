
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider/services/connectivity.dart';
import 'package:provider/provider.dart';

class NetworkWidget extends StatelessWidget {
  const NetworkWidget({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<ConnectionStatus>(context);
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    if (network == ConnectionStatus.wifi ||
        network == ConnectionStatus.mobileData) {
      return Container(
        child: child,
      );
    }

    return Container(
      height: _height,
      width: _width,
      child: Text('No wifi'),
    );
  }
}
