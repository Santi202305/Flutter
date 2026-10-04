import 'dart:async';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? _timer;
  int _millisecondsElapsed = 0;
  bool _isRunning = false;
  bool _isPaused = false;

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    print('⏱️ [Console Log - Timer] Cronómetro iniciado.');
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          _millisecondsElapsed += 100;
        });
      }
    });
  }

  void _pauseTimer() {
    if (!_isRunning || _isPaused) return;

    _timer?.cancel();
    _timer = null;

    setState(() {
      _isRunning = false;
      _isPaused = true;
    });

    print('⏸️ [Console Log - Timer] Cronómetro pausado a los ${_formatTime(_millisecondsElapsed)}.');
  }

  void _resumeTimer() {
    if (_isRunning || !_isPaused) return;

    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    print('▶️ [Console Log - Timer] Cronómetro reanudado.');
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          _millisecondsElapsed += 100;
        });
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = null;

    setState(() {
      _millisecondsElapsed = 0;
      _isRunning = false;
      _isPaused = false;
    });

    print('🔄 [Console Log - Timer] Cronómetro reiniciado a 00:00.0.');
  }

  @override
  void dispose() {
    print('🧹 [Console Log - Timer] Canceling Timer resource in dispose().');
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  String _formatTime(int totalMilliseconds) {
    int minutes = (totalMilliseconds ~/ 60000);
    int seconds = (totalMilliseconds % 60000) ~/ 1000;
    int tenths = (totalMilliseconds % 1000) ~/ 100;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr.$tenths';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('2. Timer (Cronómetro)'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner de la función
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: theme.colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer_rounded,
                      size: 36,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cronómetro de Alta Precisión',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Actualización periódica cada 100 ms usando Timer.periodic con limpieza garantizada de recursos.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 36),

            // Marcador de Tiempo Principal (Marcador Digital)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey.shade900, Colors.black87],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: _isRunning
                        ? Colors.lightGreenAccent
                        : (_isPaused ? Colors.amberAccent : Colors.grey.shade700),
                    width: 2.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      _formatTime(_millisecondsElapsed),
                      style: TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        color: _isRunning
                            ? Colors.lightGreenAccent
                            : (_isPaused ? Colors.amberAccent : Colors.white),
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isRunning
                              ? Icons.play_arrow_rounded
                              : (_isPaused ? Icons.pause_rounded : Icons.stop_rounded),
                          size: 16,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _isRunning
                              ? 'EJECUTANDO (100 ms)'
                              : (_isPaused ? 'PAUSADO' : 'DETENIDO'),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Panel de Control de Botones
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                // Iniciar
                ElevatedButton.icon(
                  onPressed: (!_isRunning && !_isPaused) ? _startTimer : null,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Iniciar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),

                // Pausar
                ElevatedButton.icon(
                  onPressed: _isRunning ? _pauseTimer : null,
                  icon: const Icon(Icons.pause_rounded),
                  label: const Text('Pausar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),

                // Reanudar
                ElevatedButton.icon(
                  onPressed: _isPaused ? _resumeTimer : null,
                  icon: const Icon(Icons.play_circle_fill_rounded),
                  label: const Text('Reanudar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),

                // Reiniciar
                ElevatedButton.icon(
                  onPressed: (_millisecondsElapsed > 0) ? _resetTimer : null,
                  icon: const Icon(Icons.restart_alt_rounded),
                  label: const Text('Reiniciar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Tarjeta Informativa de Limpieza
            Card(
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.blue.shade200),
              ),
              child: const Padding(
                padding: EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    Icon(Icons.cleaning_services_rounded, color: Colors.blue),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Limpieza de Recursos: El método dispose() invoca cancel() en el Timer al salir de esta vista para evitar fugas de memoria (memory leaks).',
                        style: TextStyle(fontSize: 12.5, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
