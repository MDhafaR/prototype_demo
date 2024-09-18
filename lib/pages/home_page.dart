part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MapController _mapController;
  Position? _currentPosition;
  bool _isLoading = false;
  List<LatLng> _routePoints = [];

  Future<void> _getCurrentPosition() async {
    setState(() {
      _isLoading = true;
    });
    final isLocationGranted = await Utility.instance.checkLocationPermission();
    if (!isLocationGranted) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _centerOnCurrentLocation() {
    if (_currentPosition != null) {
      _mapController.move(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        16,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prototype Demo'),
      ),
      body: Stack(
        children: [
          FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(-6.9481298, 107.6595105),
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.technoinfinity.prototype',
                ),
                MarkerLayer(markers: [
                  Marker(
                    rotate: true,
                    height: 50,
                    width: 50,
                    point: LatLng(-6.9481298, 107.6595104),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _routePoints = [
                            LatLng(-6.9481298, 107.6595104),
                            LatLng(_currentPosition!.latitude,
                                _currentPosition!.longitude)
                          ];
                        });
                      },
                      icon: Icon(Icons.location_on, size: 50),
                    ),
                  ),
                  Marker(
                      rotate: true,
                      height: 50,
                      width: 50,
                      point: LatLng(-6.9539400, 107.6599104),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _routePoints = [
                              LatLng(-6.9539400, 107.6599104),
                              LatLng(_currentPosition!.latitude,
                                  _currentPosition!.longitude)
                            ];
                          });
                        },
                        icon: Icon(Icons.location_on, size: 50),
                      )),
                  Marker(
                    rotate: true,
                    height: 50,
                    width: 50,
                    point: LatLng(-6.9481298, 107.6634104),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _routePoints = [
                            LatLng(-6.9481298, 107.6634104),
                            LatLng(_currentPosition!.latitude,
                                _currentPosition!.longitude)
                          ];
                        });
                      },
                      icon: Icon(Icons.location_on, size: 50),
                    ),
                  ),
                  if (_currentPosition != null) ...[
                    Marker(
                      rotate: true,
                      height: 40,
                      width: 40,
                      point: LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude),
                      child:
                          Icon(Icons.my_location, size: 50, color: Colors.blue),
                    ),
                  ],
                ]),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: Colors
                          .green, // Asumsi ColorsLib.hijau adalah warna hijau
                      strokeWidth: 5,
                    ),
                  ],
                ),
              ]),
          if (_isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

class Utility {
  static final instance = Utility._();

  factory Utility() => instance;

  Utility._();

  final localAuth = LocalAuthentication();

  Future<bool> checkLocationPermission() async {
    if (await Permission.location.serviceStatus.isDisabled) {
      Get.rawSnackbar(
          message:
              'Location services are disabled. Please enable the services');
      return false;
    }
    var status = await Permission.location.status;

    if (status.isDenied) {
      status = await Permission.location.request();
      if (status.isDenied) {
        Get.rawSnackbar(message: 'Location permissions are denied');
        return false;
      }
    }
    if (status.isPermanentlyDenied) {
      Get.rawSnackbar(
          message:
              'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    return true;
  }
}
