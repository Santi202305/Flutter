import 'dart:async';
import 'dart:isolate';

/// Clase que empaqueta los parámetros enviados al Isolate
class IsolateWorkPayload {
  final SendPort sendPort;
  final int limit;

  IsolateWorkPayload({required this.sendPort, required this.limit});
}

/// Clase que empaqueta los mensajes recibidos del Isolate
class IsolateResponseMessage {
  final String status; // 'PROGRESS', 'SUCCESS', 'ERROR'
  final double? progress;
  final BigInt? result;
  final int? executionTimeMs;
  final String? errorMessage;

  IsolateResponseMessage({
    required this.status,
    this.progress,
    this.result,
    this.executionTimeMs,
    this.errorMessage,
  });
}

class IsolateService {
  /// Ejecuta un cálculo pesadísimo (Suma de números primos hasta [limit]) usando `Isolate.spawn`
  static Future<IsolateResponseMessage> computeHeavyTask({
    required int limit,
    Function(double progress)? onProgress,
  }) async {
    final receivePort = ReceivePort();
    final completer = Completer<IsolateResponseMessage>();

    print('--------------------------------------------------');
    print('⚡ [Console Log - Isolate] 1. Creando ReceivePort y haciendo Isolate.spawn()...');

    final payload = IsolateWorkPayload(
      sendPort: receivePort.sendPort,
      limit: limit,
    );

    Isolate? isolate;

    try {
      isolate = await Isolate.spawn(_heavyCpuWorker, payload);

      receivePort.listen((dynamic message) {
        if (message is Map<String, dynamic>) {
          final type = message['type'] as String;

          if (type == 'PROGRESS') {
            final progress = message['value'] as double;
            if (onProgress != null) onProgress(progress);
            print('📩 [Console Log - Isolate] Mensaje del Isolate: Progreso ${(progress * 100).toStringAsFixed(0)}%');
          } else if (type == 'SUCCESS') {
            final result = BigInt.parse(message['result'] as String);
            final timeMs = message['timeMs'] as int;

            print('✅ [Console Log - Isolate] 2. Respuesta recibida del Isolate: Suma=${result}, Tiempo=${timeMs}ms');
            print('--------------------------------------------------');

            receivePort.close();
            isolate?.kill(priority: Isolate.immediate);

            completer.complete(IsolateResponseMessage(
              status: 'SUCCESS',
              result: result,
              executionTimeMs: timeMs,
            ));
          } else if (type == 'ERROR') {
            final err = message['error'] as String;
            print('❌ [Console Log - Isolate] Error en Isolate: $err');
            print('--------------------------------------------------');

            receivePort.close();
            isolate?.kill(priority: Isolate.immediate);

            completer.complete(IsolateResponseMessage(
              status: 'ERROR',
              errorMessage: err,
            ));
          }
        }
      });
    } catch (e) {
      print('❌ [Console Log - Isolate] Error al crear Isolate: $e');
      receivePort.close();
      isolate?.kill(priority: Isolate.immediate);
      completer.complete(IsolateResponseMessage(
        status: 'ERROR',
        errorMessage: e.toString(),
      ));
    }

    return completer.future;
  }

  /// Función estática / de nivel superior que ejecuta el trabajo pesado dentro del Isolate en otro hilo de CPU
  static void _heavyCpuWorker(IsolateWorkPayload payload) {
    final stopwatch = Stopwatch()..start();
    final sendPort = payload.sendPort;
    final limit = payload.limit;

    print('🧵 [Worker Isolate Thread] Isolate iniciado. Procesando suma de primos hasta $limit...');

    try {
      BigInt primeSum = BigInt.zero;
      int countPrimes = 0;
      int lastReportStep = limit ~/ 10;

      for (int i = 2; i <= limit; i++) {
        if (_isPrime(i)) {
          primeSum += BigInt.from(i);
          countPrimes++;
        }

        // Enviar progreso cada 10%
        if (lastReportStep > 0 && i % lastReportStep == 0) {
          double progress = i / limit;
          sendPort.send({'type': 'PROGRESS', 'value': progress});
        }
      }

      stopwatch.stop();

      sendPort.send({
        'type': 'SUCCESS',
        'result': primeSum.toString(),
        'countPrimes': countPrimes,
        'timeMs': stopwatch.elapsedMilliseconds,
      });
    } catch (e) {
      sendPort.send({'type': 'ERROR', 'error': e.toString()});
    }
  }

  /// Verificador de número primo (CPU intensive)
  static bool _isPrime(int n) {
    if (n < 2) return false;
    if (n == 2 || n == 3) return true;
    if (n % 2 == 0 || n % 3 == 0) return false;
    for (int i = 5; i * i <= n; i += 6) {
      if (n % i == 0 || n % (i + 2) == 0) return false;
    }
    return true;
  }
}
