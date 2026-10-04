import 'package:flutter_test/flutter_test.dart';
import 'package:taller2/main.dart';

void main() {
  testWidgets('Carga inicial de Taller2App', (WidgetTester tester) async {
    await tester.pumpWidget(const Taller2App());
    expect(find.text('Taller 2: Tareas en Segundo Plano'), findsOneWidget);
  });
}
