import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> checkConnection() async {
  Connectivity connectivity = Connectivity();
  final connectivityResults = await connectivity.checkConnectivity();
  if (connectivityResults.contains(ConnectivityResult.none)) return false;
  return true;
}