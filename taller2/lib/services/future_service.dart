import 'dart:async';
import 'dart:math';

/// Modelo de datos para la simulación de consulta asíncrona
class UserProfileData {
  final String id;
  final String name;
  final String role;
  final String email;
  final int tasksCompleted;
  final double rating;

  UserProfileData({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.tasksCompleted,
    required this.rating,
  });
}

/// Servicio que simula una consulta de red usando `Future` y `async`/`await`
class FutureService {
  /// Simula la obtención de datos de un usuario tras un retardo de 2.5 segundos.
  /// Si [forceError] es true, lanzará un error simulado para probar el estado de error.
  Future<UserProfileData> fetchUserData({bool forceError = false}) async {
    print('--------------------------------------------------');
    print('🌐 [Console Log - Future] 1. ANTES: Iniciando consulta asíncrona con fetchUserData()...');
    print('🌐 [Console Log - Future] 2. DURANTE: Ejecutando Future.delayed(2.5 s). Hilo principal NO bloqueado.');

    // Simular latencia de red de 2.5 segundos
    await Future.delayed(const Duration(milliseconds: 2500));

    if (forceError) {
      print('❌ [Console Log - Future] 3. DESPUÉS: Ocurrió un error en el servicio asíncrono.');
      print('--------------------------------------------------');
      throw Exception('Error 500: Fallo de conexión con el servidor simulado.');
    }

    final mockUser = UserProfileData(
      id: 'USR-${Random().nextInt(9000) + 1000}',
      name: 'Santiago Morales',
      role: 'Desarrollador Flutter Senior',
      email: 'santiago.morales@universidad.edu.co',
      tasksCompleted: 42,
      rating: 4.95,
    );

    print('✅ [Console Log - Future] 3. DESPUÉS: Consulta finalizada exitosamente. Datos recibidos: ${mockUser.name}');
    print('--------------------------------------------------');

    return mockUser;
  }
}
