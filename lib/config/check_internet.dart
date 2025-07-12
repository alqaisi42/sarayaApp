import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';





class CheckInternet {
  static final Connectivity connectivity = Connectivity();
  static List<ConnectivityResult> connectionStatus = [];

  static Future<List<ConnectivityResult>> initConnectivity() async {
    try {
      final result = await connectivity.checkConnectivity();
      return updateConnectionStatus(result);
    } catch (e) {
      debugPrint('Connectivity check failed: $e');
      return [ConnectivityResult.none];
    }
  }

  static Future<List<ConnectivityResult>> updateConnectionStatus(List<ConnectivityResult> results) async {
    // Check if we have any active connection
    final hasConnection = results.any((result) =>
    result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet
    );

    connectionStatus = hasConnection ? results : [ConnectivityResult.none];
    return connectionStatus;
  }

  static bool isConnected() {
    return connectionStatus.any((result) =>
    result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet
    );
  }
}