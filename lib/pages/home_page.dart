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
  List<String> _routeInstructions = [];

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
      await _getRoute(_currentPosition!, null, null);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getRoute(
      Position start, double? endLatitude, double? endLongitude) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final OpenRouteService client = OpenRouteService(
        apiKey: '5b3ce3597851110001cf6248387193944b4147e28f526f7e9b949e63',
      );
      final List<ORSCoordinate> routeCoordinates =
          await client.directionsRouteCoordsGet(
        startCoordinate:
            ORSCoordinate(latitude: start.latitude, longitude: start.longitude),
        endCoordinate: ORSCoordinate(
            latitude: endLatitude ?? start.latitude,
            longitude: endLongitude ?? start.longitude),
      );
      final List<LatLng> routePoints = routeCoordinates
          .map(
              (coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
          .toList();

      // Get route instructions
      final response = await client.directionsRouteGeoJsonGet(
        startCoordinate:
            ORSCoordinate(latitude: start.latitude, longitude: start.longitude),
        endCoordinate: ORSCoordinate(
            latitude: endLatitude ?? start.latitude,
            longitude: endLongitude ?? start.longitude),
      );

      // Parse instructions
      final List<String> instructions = [];
      if (response.features.isNotEmpty) {
        final feature = response.features[0];
        final segments = feature.properties['segments'] as List;
        for (var segment in segments) {
          if (segment['steps'] != null) {
            for (var step in segment['steps']) {
              if (step['instruction'] != null) {
                instructions.add(step['instruction']);
              }
            }
          }
        }
      }

      setState(() {
        _routePoints = routePoints;
        _routeInstructions = instructions;
      });

      // Start following the route
      _startRouteAnimation();
    } catch (e) {
      debugPrint('Error getting route: ${e.toString()}');
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

  double _calculateBearing(LatLng start, LatLng end) {
    var startLat = start.latitude * pi / 180;
    var startLng = start.longitude * pi / 180;
    var endLat = end.latitude * pi / 180;
    var endLng = end.longitude * pi / 180;

    var dLng = endLng - startLng;

    var y = sin(dLng) * cos(endLat);
    var x =
        cos(startLat) * sin(endLat) - sin(startLat) * cos(endLat) * cos(dLng);

    var bearing = atan2(y, x);
    bearing = bearing * 180 / pi;
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  int _currentRouteIndex = 0;
  Timer? _routeAnimationTimer;

  void _startRouteAnimation() {
    _currentRouteIndex = 0;
    _routeAnimationTimer?.cancel();
    _routeAnimationTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_currentRouteIndex < _routePoints.length) {
        _mapController.move(_routePoints[_currentRouteIndex], 16);
        _currentRouteIndex++;
      } else {
        _routeAnimationTimer?.cancel();
        // Calculate the midpoint between _routePoints[0] and _routePoints[1]
        LatLng center = LatLng(
            (_routePoints[0].latitude + _routePoints[1].latitude) / 2,
            (_routePoints[0].longitude + _routePoints[1].longitude) / 2);
        _mapController.moveAndRotate(
            center, 18, _calculateBearing(_routePoints[0], _routePoints[1]));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentPosition();
  }

  @override
  void dispose() {
    _routeAnimationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prototype Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _centerOnCurrentLocation,
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () {
              _routeAnimationTimer?.cancel();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
              mapController: _mapController,
              options: const MapOptions(
                initialCenter: LatLng(-6.9481298, 107.6595105),
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
                    point: const LatLng(-6.9481298, 107.6595104),
                    child: IconButton(
                      onPressed: () {
                        _getRoute(_currentPosition!, -6.9481298, 107.6595104);
                      },
                      icon: const Icon(Icons.location_on, size: 50),
                    ),
                  ),
                  Marker(
                      rotate: true,
                      height: 50,
                      width: 50,
                      point: const LatLng(-6.9539400, 107.6599104),
                      child: IconButton(
                        onPressed: () {
                          _getRoute(_currentPosition!, -6.9539400, 107.6599104);
                        },
                        icon: const Icon(Icons.location_on, size: 50),
                      )),
                  Marker(
                    rotate: true,
                    height: 50,
                    width: 50,
                    point: const LatLng(-6.9481298, 107.6634104),
                    child: IconButton(
                      onPressed: () {
                        _getRoute(_currentPosition!, -6.9481298, 107.6634104);
                      },
                      icon: const Icon(Icons.location_on, size: 50),
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
                          const Icon(Icons.my_location, size: 50, color: Colors.blue),
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
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24)),
            ),
            height: 240,
            child: ListView.builder(
              itemCount: _routeInstructions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.directions),
                  title: Text(_routeInstructions[index]),
                );
              },
            ),
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
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
