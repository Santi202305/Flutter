import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller2/screens/future_screen.dart';
import 'package:taller2/screens/timer_screen.dart';
import 'package:taller2/screens/isolate_screen.dart';

void main() {
  Widget buildWrapper(Widget child) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.light,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: 440,
            height: 900,
            child: child,
          ),
        ),
      ),
    );
  }

  // --- FUTURE SCREEN ---
  testWidgets('01 Future Screen Inicial', (WidgetTester tester) async {
    await tester.pumpWidget(buildWrapper(const FutureScreen()));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../docs/screenshots/taller2/01_future_estado_inicial.png'),
    );
  });

  testWidgets('02 Future Screen Cargando', (WidgetTester tester) async {
    await tester.pumpWidget(buildWrapper(const FutureScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cargar Datos (Éxito)'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../docs/screenshots/taller2/02_future_cargando.png'),
    );
    await tester.pump(const Duration(milliseconds: 3000));
  });

  testWidgets('03 Future Screen Éxito', (WidgetTester tester) async {
    await tester.pumpWidget(buildWrapper(const FutureScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cargar Datos (Éxito)'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../docs/screenshots/taller2/03_future_exito.png'),
    );
  });

  testWidgets('04 Future Screen Error', (WidgetTester tester) async {
    await tester.pumpWidget(buildWrapper(const FutureScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simular Error'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../docs/screenshots/taller2/04_future_error.png'),
    );
  });

  // --- TIMER SCREEN ---
  testWidgets('05 Timer Screen Reiniciado', (WidgetTester tester) async {
    await tester.pumpWidget(buildWrapper(const TimerScreen()));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../docs/screenshots/taller2/05_timer_reiniciado.png'),
    );
  });

  testWidgets('06 Timer Screen Corriendo', (WidgetTester tester) async {
    await tester.pumpWidget(buildWrapper(const TimerScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 3500));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../docs/screenshots/taller2/06_timer_corriendo.png'),
    );
  });

  testWidgets('07 Timer Screen Pausado', (WidgetTester tester) async {
    await tester.pumpWidget(buildWrapper(const TimerScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2400));
    await tester.tap(find.text('Pausar'));
    await tester.pump();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../docs/screenshots/taller2/07_timer_pausado.png'),
    );
  });

  // --- ISOLATE SCREEN ---
  testWidgets('08 Isolate Screen Inicial', (WidgetTester tester) async {
    await tester.pumpWidget(buildWrapper(const IsolateScreen()));
    await tester.pump(const Duration(milliseconds: 300));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../docs/screenshots/taller2/08_isolate_estado_inicial.png'),
    );
  });

  testWidgets('09 Isolate Screen Procesando', (WidgetTester tester) async {
    await tester.pumpWidget(buildWrapper(const IsolateScreen()));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Ejecutar Tarea Pesada en Isolate'), warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../docs/screenshots/taller2/09_isolate_procesando.png'),
    );
  });

  testWidgets('10 Isolate Screen Resultado', (WidgetTester tester) async {
    await tester.pumpWidget(buildWrapper(const IsolateScreen()));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.runAsync(() async {
      final button = find.text('Ejecutar Tarea Pesada en Isolate');
      await tester.tap(button, warnIfMissed: false);
      await Future.delayed(const Duration(seconds: 4));
    });

    await tester.pump(const Duration(milliseconds: 500));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../docs/screenshots/taller2/10_isolate_resultado.png'),
    );
  });
}
