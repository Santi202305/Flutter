import 'package:flutter/material.dart';
import '../services/future_service.dart';

enum ViewState { initial, loading, success, error }

class FutureScreen extends StatefulWidget {
  const FutureScreen({super.key});

  @override
  State<FutureScreen> createState() => _FutureScreenState();
}

class _FutureScreenState extends State<FutureScreen> {
  final FutureService _futureService = FutureService();
  ViewState _state = ViewState.initial;
  UserProfileData? _userData;
  String? _errorMessage;

  Future<void> _loadData({bool forceError = false}) async {
    setState(() {
      _state = ViewState.loading;
      _errorMessage = null;
    });

    try {
      // Demostración explícita de async/await
      final data = await _futureService.fetchUserData(forceError: forceError);

      if (!mounted) return;
      setState(() {
        _userData = data;
        _state = ViewState.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _state = ViewState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('1. Future & async/await'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Explicativo
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.cloud_sync_rounded,
                          size: 32,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
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
                    const SizedBox(height: 8),
                    Text(
                      'Demuestra el uso de Future.delayed (2.5s) con async/await para consultar datos sin congelar la interfaz.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Botones de Acción
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _state == ViewState.loading
                        ? null
                        : () => _loadData(forceError: false),
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
                    onPressed: _state == ViewState.loading
                        ? null
                        : () => _loadData(forceError: true),
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

            // Área de Estado de la UI
            Text(
              'Estado de la Pantalla:',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: _buildStateContent(theme),
            ),

            const SizedBox(height: 30),

            // Panel de Orden de Ejecución en Consola
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade400, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.terminal_rounded, color: Colors.greenAccent, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Orden de Ejecución en Consola (print)',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 16),
                  const Text(
                    '1. ANTES:  Iniciando función _loadData()\n'
                    '2. DURANTE: Esperando Future.delayed(2.5 s) con await...\n'
                    '3. DESPUÉS: Proceso asíncrono finalizado (Éxito / Error)',
                    style: TextStyle(
                      color: Color(0xE6FFFFFF),
                      fontSize: 12.5,
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

  Widget _buildStateContent(ThemeData theme) {
    switch (_state) {
      case ViewState.initial:
        return Card(
          key: const ValueKey('initial'),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Icon(Icons.touch_app_rounded, size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text(
                  'Presiona un botón arriba para iniciar la consulta asíncrona',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        );

      case ViewState.loading:
        return Card(
          key: const ValueKey('loading'),
          elevation: 2,
          color: Colors.amber.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.amber.shade300, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                const CircularProgressIndicator(strokeWidth: 3),
                const SizedBox(height: 20),
                Text(
                  'Cargando datos...',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Esperando Future.delayed (2.5 segundos)...',
                  style: TextStyle(color: Colors.amber.shade800, fontSize: 13),
                ),
              ],
            ),
          ),
        );

      case ViewState.success:
        return Card(
          key: const ValueKey('success'),
          elevation: 3,
          color: Colors.green.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.green.shade400, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
                    const SizedBox(width: 10),
                    Text(
                      'Estado: ¡Éxito!',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildDataRow(Icons.badge, 'ID Usuario:', _userData?.id ?? ''),
                _buildDataRow(Icons.person, 'Nombre:', _userData?.name ?? ''),
                _buildDataRow(Icons.work, 'Rol:', _userData?.role ?? ''),
                _buildDataRow(Icons.email, 'Correo:', _userData?.email ?? ''),
                _buildDataRow(Icons.task_alt, 'Tareas Completadas:', '${_userData?.tasksCompleted}'),
                _buildDataRow(Icons.star, 'Calificación:', '⭐ ${_userData?.rating}'),
              ],
            ),
          ),
        );

      case ViewState.error:
        return Card(
          key: const ValueKey('error'),
          elevation: 3,
          color: Colors.red.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.red.shade400, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Icon(Icons.error_rounded, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text(
                  'Estado: Fallo en la Operación',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _errorMessage ?? 'Ocurrió un error inesperado',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red.shade800),
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildDataRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.green.shade700),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade900, fontSize: 13.5),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
