import 'dart:async';

import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  ///Connection status controller....
  StreamController<ConnectionStatus> connectivityController =
      StreamController<ConnectionStatus>();

  ///Fetch the Connection Status...
  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult status) {
      var _connectionStatus = _networkStatus(status);

      ///Emit the status via Stream...
      connectivityController.add(_connectionStatus);
    });
  }

  //Converts the connectivity result into our enums
  //Currently the output id mobile, wifi,none.....
  ConnectionStatus _networkStatus(ConnectivityResult status) {
    //Begin...

    switch (status) {
      case ConnectivityResult.mobile:
        return ConnectionStatus.mobileData;

      case ConnectivityResult.wifi:
        return ConnectionStatus.wifi;

      case ConnectivityResult.none:
        return ConnectionStatus.offline;

      default:
        return ConnectionStatus.offline;
    }
  }
}

enum ConnectionStatus {
  wifi,
  mobileData,
  offline,
}
