import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller2/screens/future_screen.dart';
import 'package:taller2/screens/timer_screen.dart';
import 'package:taller2/screens/isolate_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> save(WidgetTester tester, Widget child, String fileName) async {
    final repaintKey = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.teal,
          brightness: Brightness.light,
        ),
        home: Scaffold(
          body: RepaintBoundary(
            key: repaintKey,
            child: SizedBox(
              width: 420,
              height: 820,
              child: child,
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    final RenderRepaintBoundary boundary =
        repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    final dir = Directory('../docs/screenshots/taller2');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    final file = File('../docs/screenshots/taller2/$fileName');
    await file.writeAsBytes(buffer);
    print('✅ Saved: ${file.path}');
  }

  testWidgets('Generate Screenshots', (WidgetTester tester) async {
    // 1. Future Screen - State 1: Inicial
    await save(tester, const FutureScreen(), '01_future_estado_inicial.png');

    // 2. Timer Screen - State: Reiniciado / Inicial
    await save(tester, const TimerScreen(), '05_timer_reiniciado.png');

    // 3. Isolate Screen - State: Inicial
    await save(tester, const IsolateScreen(), '08_isolate_estado_inicial.png');
  });
}
