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

  Future<void> renderAndSave(WidgetTester tester, Widget screenWidget, String fileName) async {
    final GlobalKey repaintKey = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.teal,
          brightness: Brightness.light,
        ),
        home: RepaintBoundary(
          key: repaintKey,
          child: SizedBox(
            width: 440,
            height: 840,
            child: screenWidget,
          ),
        ),
      ),
    );
    await tester.pump();

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
    print('📸 Screenshot guardado: ${file.path}');
  }

  testWidgets('01 Future Screen Inicial', (WidgetTester tester) async {
    await renderAndSave(tester, const FutureScreen(), '01_future_estado_inicial.png');
  });

  testWidgets('02 Future Screen Cargando', (WidgetTester tester) async {
    await renderAndSave(tester, const FutureScreen(), '02_future_cargando.png');
    final btn = find.text('Cargar Datos (Éxito)');
    await tester.tap(btn);
    await tester.pump();
    await renderAndSave(tester, const FutureScreen(), '02_future_cargando.png');
  });

  testWidgets('05 Timer Screen Reiniciado', (WidgetTester tester) async {
    await renderAndSave(tester, const TimerScreen(), '05_timer_reiniciado.png');
  });

  testWidgets('08 Isolate Screen Inicial', (WidgetTester tester) async {
    await renderAndSave(tester, const IsolateScreen(), '08_isolate_estado_inicial.png');
  });
}
