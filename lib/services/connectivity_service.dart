import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamController<bool> connectionStatusController =
      StreamController<bool>.broadcast();

  // Initialize the connectivity service and start listening for changes
  ConnectivityService() {
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus as void
        Function(List<ConnectivityResult> event)?);
  }

  // Check initial connectivity status
  Future<void> _initConnectivity() async {
    try {
      ConnectivityResult result =
          (await _connectivity.checkConnectivity()) as ConnectivityResult;
      _updateConnectionStatus(result);
    } catch (e) {
      print('Connectivity initialization error: $e');
      connectionStatusController.add(false);
    }
  }

  // Update connection status based on connectivity result
  void _updateConnectionStatus(ConnectivityResult result) {
    bool isConnected = result != ConnectivityResult.none;
    connectionStatusController.add(isConnected);
  }

  // Check if device is currently connected
  Future<bool> isConnected() async {
    try {
      ConnectivityResult result =
          (await _connectivity.checkConnectivity()) as ConnectivityResult;
      return result != ConnectivityResult.none;
    } catch (e) {
      print('Error checking connectivity: $e');
      return false;
    }
  }

  // Stream of connectivity status changes
  Stream<bool> get connectionStream => connectionStatusController.stream;

  // Dispose resources
  void dispose() {
    connectionStatusController.close();
  }
}
