import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class WifiConnection {
  StreamSubscription? _streamSubscription;
  bool? isDevicedConnected;
  String? connectionStatus;

  Future<bool> getConnectivity() async {
    _streamSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print('New connectivity status: $result');
    });
    var connectivityResult = await Connectivity().checkConnectivity();
    print(connectivityResult);
    if (connectivityResult != ConnectivityResult.none) {
      print('Conectado a una red de internet');
      connectionStatus = 'connected';
      return true;
    } else {
      print('No conectado a una red de internet');
      connectionStatus = 'disconnected';
      return false;
    }
  }

  void dispose() {
    _streamSubscription?.cancel();
  }
}