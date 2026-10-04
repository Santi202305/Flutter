import 'package:flutter/material.dart';
import '../services/isolate_service.dart';

class IsolateScreen extends StatefulWidget {
  const IsolateScreen({super.key});

  @override
  State<IsolateScreen> createState() => _IsolateScreenState();
}

class _IsolateScreenState extends State<IsolateScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  bool _isProcessing = false;
  double _progress = 0.0;
  BigInt? _resultSum;
  int? _executionTimeMs;
  String? _errorMessage;
  int _selectedLimit = 15000000; // Limite de numeros primos

  @override
  void initState() {
    super.initState();
    // Animación continua para demostrar que la UI NO se congela durante la ejecución del Isolate
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _runIsolateTask() async {
    setState(() {
      _isProcessing = true;
      _progress = 0.0;
      _resultSum = null;
      _executionTimeMs = null;
      _errorMessage = null;
    });

    final response = await IsolateService.computeHeavyTask(
      limit: _selectedLimit,
      onProgress: (prog) {
        if (mounted) {
          setState(() {
            _progress = prog;
          });
        }
      },
    );

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
      if (response.status == 'SUCCESS') {
        _resultSum = response.result;
        _executionTimeMs = response.executionTimeMs;
      } else {
        _errorMessage = response.errorMessage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('3. Tarea Pesada con Isolate'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header del Isolate
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.purple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.memory_rounded,
                      size: 36,
                      color: Colors.purple.shade800,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Multithreading con Isolate.spawn',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ejecuta un cómputo pesado CPU-bound en un hilo independiente evitando bloquear el Event Loop de la UI.',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.purple.shade900.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Prueba de UI Fluida (Widget de Animación Continua)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  RotationTransition(
                    turns: _animationController,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.sync_rounded, color: Colors.white, size: 28),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Demostración de UI Responsiva (60 FPS)',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Esta animación sigue rotando de forma totalmente fluida mientras el Isolate realiza millones de cálculos.',
                          style: TextStyle(color: Colors.white70, fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Selector de Carga de Trabajo
            Text(
              'Seleccionar Tamaño del Cómputo (Suma de Primos):',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 5000000,
                  label: Text('5 Millones'),
                  icon: Icon(Icons.speed),
                ),
                ButtonSegment(
                  value: 15000000,
                  label: Text('15 Millones'),
                  icon: Icon(Icons.bolt),
                ),
                ButtonSegment(
                  value: 30000000,
                  label: Text('30 Millones'),
                  icon: Icon(Icons.local_fire_department),
                ),
              ],
              selected: {_selectedLimit},
              onSelectionChanged: _isProcessing
                  ? null
                  : (newSelection) {
                      setState(() {
                        _selectedLimit = newSelection.first;
                      });
                    },
            ),
            const SizedBox(height: 24),

            // Botón de Ejecución
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isProcessing ? null : _runIsolateTask,
                icon: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.play_arrow_rounded),
                label: Text(
                  _isProcessing
                      ? 'Procesando en Isolate... (${(_progress * 100).toStringAsFixed(0)}%)'
                      : 'Ejecutar Tarea Pesada en Isolate',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Barra de Progreso
            if (_isProcessing) ...[
              LinearProgressIndicator(
                value: _progress > 0 ? _progress : null,
                backgroundColor: Colors.purple.shade100,
                color: Colors.purple.shade700,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 16),
            ],

            // Panel de Resultados
            if (_resultSum != null) ...[
              Card(
                elevation: 3,
                color: Colors.purple.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.purple.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.task_alt_rounded, color: Colors.purple, size: 28),
                          const SizedBox(width: 10),
                          Text(
                            '¡Resultado del Isolate!',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade900,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Text(
                        'Tiempo Transcurrido:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Text(
                        '⏱️ $_executionTimeMs ms (${(_executionTimeMs! / 1000).toStringAsFixed(2)} segundos)',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Suma Total de Números Primos:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      SelectableText(
                        '$_resultSum',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            if (_errorMessage != null) ...[
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error: $_errorMessage',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Registro de Mensajes Isolate en Consola
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purpleAccent, width: 1.5),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.terminal_rounded, color: Colors.purpleAccent, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Comunicación por Mensajes (ReceivePort / SendPort)',
                          style: TextStyle(
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.white24, height: 16),
                  Text(
                    '1. Main Isolate ➔ Isolate.spawn(payload, sendPort)\n'
                    '2. Worker Isolate ➔ Ejecutando _heavyCpuWorker en Hilo CPU secundario\n'
                    '3. Worker Isolate ➔ sendPort.send({\'type\': \'PROGRESS\', \'value\': 0.50})\n'
                    '4. Main Isolate ➔ receivePort.listen() recibe y actualiza la UI\n'
                    '5. Worker Isolate ➔ sendPort.send({\'type\': \'SUCCESS\', \'result\': ...})\n'
                    '6. Main Isolate ➔ Recibe respuesta, cierra ReceivePort y libera Isolate',
                    style: TextStyle(
                      color: Color(0xE6FFFFFF),
                      fontSize: 11.5,
                      fontFamily: 'monospace',
                      height: 1.5,
                    ),
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
