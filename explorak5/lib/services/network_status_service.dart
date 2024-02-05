import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:explorak5/screens/splash_screen.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:flutter/material.dart';


import '../widgets/no_wifi_widget.dart';

class NetworkStatusService extends GetxService {
  NetworkStatusService() {
    Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        _getNetworkStatus(result);
      },
    );
  }

  void _getNetworkStatus(ConnectivityResult result) async {
    bool isDevicedConnected = await InternetConnectionChecker().hasConnection;
    if (isDevicedConnected) {
      _validateSession(); //after internet connected it will redirect to home page
    } else {
      Get.dialog(NetworkErrorItem(),
          useSafeArea:
              false); // If internet loss then it will show the NetworkErrorItem widget
    }
  }

  void _validateSession() {
    Get.dialog(SplashScreen(key: UniqueKey()), useSafeArea: false);
  }
}
