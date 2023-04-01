import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityServices {
  final Connectivity _connectivity = Connectivity();
  final Function(bool) onConnectivityChanged;

  ConnectivityServices({
    required this.onConnectivityChanged,
  });

  /// This parameter store count the number of invocations to  '_updateConnectionStatus' function
  /// cause we don't want to inform user about the connection status when he just opened the app.
  static int _numberOfInvocations = 0;

  Future<void> initConnectivityServices() async {
    await _connectivity.checkConnectivity().then((connectivityResult) {
      bool isNotConnected = connectivityResult == ConnectivityResult.none;
      if (_numberOfInvocations == 0 && isNotConnected) {
        onConnectivityChanged(isNotConnected);
      }
    });
    _connectivity.onConnectivityChanged.listen(
          (connectionStatus) =>
          _updateConnectionStatus(
            currentResult: connectionStatus,
          ),
    );
  }

  Future<void> _updateConnectionStatus({
    required ConnectivityResult currentResult,
  }) async {
    if (_numberOfInvocations == 0 && currentResult != ConnectivityResult.none) return;
    _numberOfInvocations++;
    bool isNotConnected = currentResult == ConnectivityResult.none;
    onConnectivityChanged(isNotConnected);
  }

  static Future<bool> checkInternetConnection() async {
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
