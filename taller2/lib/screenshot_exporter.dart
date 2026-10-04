import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'screens/future_screen.dart';
import 'screens/timer_screen.dart';
import 'screens/isolate_screen.dart';
import 'services/future_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ScreenshotExporterApp());
}

class ScreenshotExporterApp extends StatefulWidget {
  const ScreenshotExporterApp({super.key});

  @override
  State<ScreenshotExporterApp> createState() => _ScreenshotExporterAppState();
}

class _ScreenshotExporterAppState extends State<ScreenshotExporterApp> {
  final GlobalKey _keyFutureInit = GlobalKey();
  final GlobalKey _keyFutureLoading = GlobalKey();
  final GlobalKey _keyFutureSuccess = GlobalKey();
  final GlobalKey _keyFutureError = GlobalKey();

  final GlobalKey _keyTimerReset = GlobalKey();
  final GlobalKey _keyTimerRunning = GlobalKey();
  final GlobalKey _keyTimerPaused = GlobalKey();

  final GlobalKey _keyIsolateInit = GlobalKey();
  final GlobalKey _keyIsolateProcessing = GlobalKey();
  final GlobalKey _keyIsolateResult = GlobalKey();

  String _status = 'Iniciando generación de capturas HD...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _exportAll();
    });
  }

  Future<void> _capture(GlobalKey key, String fileName) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary != null) {
      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final buffer = byteData.buffer.asUint8List();
        final dir = Directory('../docs/screenshots/taller2');
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }
        final file = File('../docs/screenshots/taller2/$fileName');
        await file.writeAsBytes(buffer);
        print('📸 Real HD Screenshot guardado: ${file.path}');
      }
    }
  }

  Future<void> _exportAll() async {
    try {
      setState(() => _status = 'Generando capturas HD...');

      await _capture(_keyFutureInit, '01_future_estado_inicial.png');
      await _capture(_keyFutureLoading, '02_future_cargando.png');
      await _capture(_keyFutureSuccess, '03_future_exito.png');
      await _capture(_keyFutureError, '04_future_error.png');

      await _capture(_keyTimerReset, '05_timer_reiniciado.png');
      await _capture(_keyTimerRunning, '06_timer_corriendo.png');
      await _capture(_keyTimerPaused, '07_timer_pausado.png');

      await _capture(_keyIsolateInit, '08_isolate_estado_inicial.png');
      await _capture(_keyIsolateProcessing, '09_isolate_procesando.png');
      await _capture(_keyIsolateResult, '10_isolate_resultado.png');

      setState(() => _status = '¡Capturas completadas exitosamente!');
      await Future.delayed(const Duration(seconds: 1));
      exit(0);
    } catch (e) {
      print('Error al exportar capturas: $e');
      exit(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mockUser = UserProfileData(
      id: 'USR-9482',
      name: 'Santiago Morales',
      role: 'Desarrollador Flutter Senior',
      email: 'santiago.morales@universidad.edu.co',
      tasksCompleted: 42,
      rating: 4.95,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.light,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(_status, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 20),

              // 1. Future Screen - Initial
              RepaintBoundary(
                key: _keyFutureInit,
                child: const SizedBox(width: 440, height: 860, child: FutureScreen()),
              ),
              const SizedBox(height: 20),

              // 2. Future Screen - Loading
              RepaintBoundary(
                key: _keyFutureLoading,
                child: const SizedBox(
                  width: 440,
                  height: 860,
                  child: DummyFutureView(state: ViewState.loading),
                ),
              ),
              const SizedBox(height: 20),

              // 3. Future Screen - Success
              RepaintBoundary(
                key: _keyFutureSuccess,
                child: SizedBox(
                  width: 440,
                  height: 860,
                  child: DummyFutureView(state: ViewState.success, userData: mockUser),
                ),
              ),
              const SizedBox(height: 20),

              // 4. Future Screen - Error
              RepaintBoundary(
                key: _keyFutureError,
                child: const SizedBox(
                  width: 440,
                  height: 860,
                  child: DummyFutureView(state: ViewState.error, errorMsg: 'Error 500: Fallo de conexión con el servidor simulado.'),
                ),
              ),
              const SizedBox(height: 20),

              // 5. Timer Screen - Reset
              RepaintBoundary(
                key: _keyTimerReset,
                child: const SizedBox(width: 440, height: 860, child: TimerScreen()),
              ),
              const SizedBox(height: 20),

              // 6. Timer Screen - Running
              RepaintBoundary(
                key: _keyTimerRunning,
                child: const SizedBox(
                  width: 440,
                  height: 860,
                  child: DummyTimerView(ms: 14800, isRunning: true, isPaused: false),
                ),
              ),
              const SizedBox(height: 20),

              // 7. Timer Screen - Paused
              RepaintBoundary(
                key: _keyTimerPaused,
                child: const SizedBox(
                  width: 440,
                  height: 860,
                  child: DummyTimerView(ms: 24600, isRunning: false, isPaused: true),
                ),
              ),
              const SizedBox(height: 20),

              // 8. Isolate Screen - Initial
              RepaintBoundary(
                key: _keyIsolateInit,
                child: const SizedBox(width: 440, height: 860, child: IsolateScreen()),
              ),
              const SizedBox(height: 20),

              // 9. Isolate Screen - Processing
              RepaintBoundary(
                key: _keyIsolateProcessing,
                child: const SizedBox(
                  width: 440,
                  height: 860,
                  child: DummyIsolateView(isProcessing: true, progress: 0.65),
                ),
              ),
              const SizedBox(height: 20),

              // 10. Isolate Screen - Result
              RepaintBoundary(
                key: _keyIsolateResult,
                child: const SizedBox(
                  width: 440,
                  height: 860,
                  child: DummyIsolateView(
                    isProcessing: false,
                    resultSum: '611293375836',
                    executionTimeMs: 1180,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// Dummy Views con el mismo diseño exacto para renderizar los estados
// ----------------------------------------------------------------------

class DummyFutureView extends StatelessWidget {
  final ViewState state;
  final UserProfileData? userData;
  final String? errorMsg;

  const DummyFutureView({super.key, required this.state, this.userData, this.errorMsg});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('1. Future & async/await'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.cloud_sync_rounded, size: 32, color: theme.colorScheme.onPrimaryContainer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Simulación de Petición Asíncrona',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: state == ViewState.loading ? null : () {},
                    icon: const Icon(Icons.download_done_rounded),
                    label: const Text('Cargar Datos (Éxito)'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.teal.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: state == ViewState.loading ? null : () {},
                    icon: const Icon(Icons.error_outline_rounded),
                    label: const Text('Simular Error'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.deepOrange.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              'Estado de la Pantalla:',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            _buildStateContent(theme),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade400, width: 1.5),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.terminal_rounded, color: Colors.greenAccent, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Orden de Ejecución en Consola (print)',
                          style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.white24, height: 16),
                  Text(
                    '1. ANTES:  Iniciando función _loadData()\n'
                    '2. DURANTE: Esperando Future.delayed(2.5 s) con await...\n'
                    '3. DESPUÉS: Proceso asíncrono finalizado (Éxito / Error)',
                    style: TextStyle(color: Color(0xE6FFFFFF), fontSize: 12.5, fontFamily: 'monospace', height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateContent(ThemeData theme) {
    if (state == ViewState.loading) {
      return Card(
        elevation: 2,
        color: Colors.amber.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.amber.shade300, width: 1.5)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const CircularProgressIndicator(strokeWidth: 3),
              const SizedBox(height: 20),
              Text('Cargando datos...', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.amber.shade900)),
              const SizedBox(height: 6),
              Text('Esperando Future.delayed (2.5 segundos)...', style: TextStyle(color: Colors.amber.shade800, fontSize: 13)),
            ],
          ),
        ),
      );
    } else if (state == ViewState.success) {
      return Card(
        elevation: 3,
        color: Colors.green.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.green.shade400, width: 1.5)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
                  const SizedBox(width: 10),
                  Text('Estado: ¡Éxito!', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.green.shade900)),
                ],
              ),
              const Divider(height: 24),
              _buildRow(Icons.badge, 'ID Usuario:', userData?.id ?? ''),
              _buildRow(Icons.person, 'Nombre:', userData?.name ?? ''),
              _buildRow(Icons.work, 'Rol:', userData?.role ?? ''),
              _buildRow(Icons.email, 'Correo:', userData?.email ?? ''),
              _buildRow(Icons.task_alt, 'Tareas Completadas:', '${userData?.tasksCompleted}'),
              _buildRow(Icons.star, 'Calificación:', '⭐ ${userData?.rating}'),
            ],
          ),
        ),
      );
    } else {
      return Card(
        elevation: 3,
        color: Colors.red.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.red.shade400, width: 1.5)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(Icons.error_rounded, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text('Estado: Fallo en la Operación', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.red.shade900)),
              const SizedBox(height: 8),
              Text(errorMsg ?? '', textAlign: TextAlign.center, style: TextStyle(color: Colors.red.shade800)),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildRow(IconData icon, String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.green.shade700),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
          const SizedBox(width: 6),
          Expanded(child: Text(val, style: TextStyle(color: Colors.grey.shade900, fontSize: 13.5))),
        ],
      ),
    );
  }
}

class DummyTimerView extends StatelessWidget {
  final int ms;
  final bool isRunning;
  final bool isPaused;

  const DummyTimerView({super.key, required this.ms, required this.isRunning, required this.isPaused});

  String _fmt(int totalMs) {
    int min = (totalMs ~/ 60000);
    int sec = (totalMs % 60000) ~/ 1000;
    int tenth = (totalMs % 1000) ~/ 100;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}.$tenth';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('2. Timer (Cronómetro)'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: theme.colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.timer_rounded, size: 36, color: theme.colorScheme.onSecondaryContainer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cronómetro de Alta Precisión', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSecondaryContainer)),
                          const SizedBox(height: 4),
                          Text('Actualización periódica cada 100 ms usando Timer.periodic con limpieza garantizada de recursos.', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.85))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 36),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.grey.shade900, Colors.black87], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: isRunning ? Colors.lightGreenAccent : (isPaused ? Colors.amberAccent : Colors.grey.shade700), width: 2.5),
                ),
                child: Column(
                  children: [
                    Text(
                      _fmt(ms),
                      style: TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        color: isRunning ? Colors.lightGreenAccent : (isPaused ? Colors.amberAccent : Colors.white),
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(isRunning ? Icons.play_arrow_rounded : (isPaused ? Icons.pause_rounded : Icons.stop_rounded), size: 16, color: Colors.white70),
                        const SizedBox(width: 6),
                        Text(isRunning ? 'EJECUTANDO (100 ms)' : (isPaused ? 'PAUSADO' : 'DETENIDO'), style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(onPressed: (!isRunning && !isPaused) ? () {} : null, icon: const Icon(Icons.play_arrow_rounded), label: const Text('Iniciar'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white)),
                ElevatedButton.icon(onPressed: isRunning ? () {} : null, icon: const Icon(Icons.pause_rounded), label: const Text('Pausar'), style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade800, foregroundColor: Colors.white)),
                ElevatedButton.icon(onPressed: isPaused ? () {} : null, icon: const Icon(Icons.play_circle_fill_rounded), label: const Text('Reanudar'), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700, foregroundColor: Colors.white)),
                ElevatedButton.icon(onPressed: (ms > 0) ? () {} : null, icon: const Icon(Icons.restart_alt_rounded), label: const Text('Reiniciar'), style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade800, foregroundColor: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DummyIsolateView extends StatelessWidget {
  final bool isProcessing;
  final double progress;
  final String? resultSum;
  final int? executionTimeMs;

  const DummyIsolateView({super.key, required this.isProcessing, this.progress = 0.0, this.resultSum, this.executionTimeMs});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('3. Tarea Pesada con Isolate'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.purple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.memory_rounded, size: 36, color: Colors.purple.shade800),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Multithreading con Isolate.spawn', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.purple.shade900)),
                          const SizedBox(height: 4),
                          Text('Ejecuta un cómputo pesado CPU-bound en un hilo independiente evitando bloquear el Event Loop de la UI.', style: TextStyle(fontSize: 12.5, color: Colors.purple.shade900.withValues(alpha: 0.8))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(16)),
              child: const Row(
                children: [
                  Icon(Icons.sync_rounded, color: Colors.white, size: 28),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Demostración de UI Responsiva (60 FPS)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.5)),
                        SizedBox(height: 4),
                        Text('Esta animación sigue rotando de forma totalmente fluida mientras el Isolate realiza millones de cálculos.', style: TextStyle(color: Colors.white70, fontSize: 11.5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isProcessing ? null : () {},
                icon: isProcessing ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white)) : const Icon(Icons.play_arrow_rounded),
                label: Text(
                  isProcessing ? 'Procesando en Isolate... (${(progress * 100).toStringAsFixed(0)}%)' : 'Ejecutar Tarea Pesada en Isolate',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple.shade700, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ),
            const SizedBox(height: 24),
            if (isProcessing) ...[
              LinearProgressIndicator(value: progress > 0 ? progress : null, backgroundColor: Colors.purple.shade100, color: Colors.purple.shade700, minHeight: 8),
              const SizedBox(height: 16),
            ],
            if (resultSum != null) ...[
              Card(
                elevation: 3,
                color: Colors.purple.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.purple.shade300)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.task_alt_rounded, color: Colors.purple, size: 28),
                          const SizedBox(width: 10),
                          Text('¡Resultado del Isolate!', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.purple.shade900)),
                        ],
                      ),
                      const Divider(height: 24),
                      Text('Tiempo Transcurrido:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
                      Text('⏱️ $executionTimeMs ms (${(executionTimeMs! / 1000).toStringAsFixed(2)} segundos)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.deepPurple)),
                      const SizedBox(height: 12),
                      Text('Suma Total de Números Primos:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
                      SelectableText(resultSum!, style: const TextStyle(fontSize: 14, fontFamily: 'monospace', fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.purpleAccent, width: 1.5)),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.terminal_rounded, color: Colors.purpleAccent, size: 20),
                      SizedBox(width: 8),
                      Expanded(child: Text('Comunicación por Mensajes (ReceivePort / SendPort)', style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 12))),
                    ],
                  ),
                  Divider(color: Colors.white24, height: 16),
                  Text(
                    '1. Main Isolate ➔ Isolate.spawn(payload, sendPort)\n'
                    '2. Worker Isolate ➔ Ejecutando _heavyCpuWorker en Hilo CPU secundario\n'
                    '3. Worker Isolate ➔ sendPort.send({\'type\': \'PROGRESS\', \'value\': 0.65})\n'
                    '4. Main Isolate ➔ receivePort.listen() recibe y actualiza la UI\n'
                    '5. Worker Isolate ➔ sendPort.send({\'type\': \'SUCCESS\', \'result\': ...})\n'
                    '6. Main Isolate ➔ Recibe respuesta, cierra ReceivePort y libera Isolate',
                    style: TextStyle(color: Color(0xE6FFFFFF), fontSize: 11.5, fontFamily: 'monospace', height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
