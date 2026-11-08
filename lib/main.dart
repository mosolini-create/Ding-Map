import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: const Color(0xFF192A32),
                child: CustomPaint(
                  painter: MapBackgroundPainter(),
                ),
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
                onPressed: () {},
                child: const Icon(Icons.my_location),
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

class MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFF30434B)
      ..strokeWidth = 13
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final thinRoadPaint = Paint()
      ..color = const Color(0xFF263941)
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke;

    final path1 = Path()
      ..moveTo(0, size.height * 0.35)
      ..lineTo(size.width * 0.4, size.height * 0.48)
      ..lineTo(size.width, size.height * 0.28);

    final path2 = Path()
      ..moveTo(size.width * 0.2, 0)
      ..lineTo(size.width * 0.45, size.height * 0.5)
      ..lineTo(size.width * 0.25, size.height);

    final path3 = Path()
      ..moveTo(0, size.height * 0.72)
      ..lineTo(size.width, size.height * 0.65);

    canvas.drawPath(path1, roadPaint);
    canvas.drawPath(path2, roadPaint);
    canvas.drawPath(path3, thinRoadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}