part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prototype Demo'),
      ),
      body: FlutterMap(
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
      ])
    );
  }
}
