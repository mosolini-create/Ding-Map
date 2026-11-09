
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const DingApp());
}

class DingApp extends StatelessWidget {
  const DingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'دینگ',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101820),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00C9A7),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  bool isLocating = false;

  final MapController mapController = MapController();

  static const LatLng initialLocation = LatLng(35.6892, 51.3890);

  LatLng? currentLocation;

  Future<void> goToMyLocation() async {
    if (isLocating) return;

    setState(() {
      isLocating = true;
    });

    try {
      bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception('لطفاً GPS گوشی را روشن کن.');
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception('اجازه دسترسی به موقعیت داده نشد.');
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'دسترسی GPS از تنظیمات برنامه فعال شود.',
        );
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );

      final location = LatLng(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        currentLocation = location;
      });

      mapController.move(location, 16);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
            textAlign: TextAlign.right,
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLocating = false;
        });
      }
    }
  }

  void resetMap() {
    mapController.move(initialLocation, 12);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: FlutterMap(
                mapController: mapController,
                options: const MapOptions(
                  initialCenter: initialLocation,
                  initialZoom: 12,
                  minZoom: 3,
                  maxZoom: 18,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.ding',
                  ),

                  if (currentLocation != null)
                    CircleLayer(
                      circles: [
                        CircleMarker(
                          point: currentLocation!,
                          radius: 10,
                          color: const Color(0xFF00C9A7),
                          borderColor: Colors.white,
                          borderStrokeWidth: 3,
                        ),
                      ],
                    ),
                ],
              ),
            ),

            Positioned(
              top: 18,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'دینگ',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00C9A7),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'کجا می‌خوای بری؟',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: const Color(0xFF24343D),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 105,
              left: 20,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFF00C9A7),
                foregroundColor: Colors.black,
                onPressed: isLocating ? null : goToMyLocation,
                child: isLocating
                    ? const CircularProgressIndicator(
                        color: Colors.black,
                      )
                    : const Icon(Icons.my_location),
              ),
            ),

            const Positioned(
              bottom: 85,
              right: 10,
              child: Text(
                '© OpenStreetMap contributors',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  backgroundColor: Color(0x99000000),
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF17252D),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    navItem(Icons.map_outlined, 'نقشه', 0),
                    navItem(Icons.bookmark_outline, 'ذخیره‌ها', 1),
                    navItem(Icons.history, 'تاریخچه', 2),
                    navItem(Icons.person_outline, 'حساب من', 3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget navItem(IconData icon, String label, int index) {
    final selected = selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: selected
                ? const Color(0xFF00C9A7)
                : Colors.white60,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: selected
                  ? const Color(0xFF00C9A7)
                  : Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
}
