import 'package:flutter/material.dart';

void main() {
  runApp(const TallerApp());
}

class TallerApp extends StatelessWidget {
  const TallerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taller 1 - Flutter StatefulWidget',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Indigo modern
          brightness: Brightness.light,
          primary: const Color(0xFF4F46E5),
          secondary: const Color(0xFF0EA5E9),
          surface: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
          shadowColor: Colors.black26,
          backgroundColor: Color(0xFF4F46E5),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variable de estado para el título de la AppBar
  String _appBarTitle = 'Hola, Flutter';

  // Función obligatoria para alternar el título usando setState y mostrar el SnackBar
  void _toggleTitle() {
    setState(() {
      if (_appBarTitle == 'Hola, Flutter') {
        _appBarTitle = '¡Título cambiado!';
      } else {
        _appBarTitle = 'Hola, Flutter';
      }
    });

    // Mostrar SnackBar estilizado
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Título actualizado',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981), // Verde moderno
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _toggleTitle,
            tooltip: 'Cambiar Título',
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ==========================================
            // 1. HEADER / TARJETA DEL ESTUDIANTE (Text Centrado)
            // ==========================================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF0EA5E9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x334F46E5),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person_rounded, size: 40, color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Santiago',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Desarrollo de Aplicaciones Móviles - Taller 1',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ==========================================
            // 2. SECCIÓN DE IMÁGENES EN ROW (Image.network + Image.asset)
            // WIDGET ADICIONAL: Stack + Container con bordes estilizados
            // ==========================================
            const Text(
              'Galería de Imágenes (Row, Asset, Network, Stack)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Imagen 1: Image.network con Stack (Superposición de texto)
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 130,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xA6000000),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Image.network',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Imagen 2: Image.asset con Stack
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            height: 130,
                            width: double.infinity,
                            color: const Color(0xFFEEF2FF),
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              'assets/images/flutter_logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xD94F46E5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Image.asset',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ==========================================
            // 3. BOTÓN PRINCIPAL + setState() (Obligatorio)
            // ==========================================
            ElevatedButton.icon(
              onPressed: _toggleTitle,
              icon: const Icon(Icons.touch_app_rounded, size: 22),
              label: const Text(
                'Cambiar Título de la AppBar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 4,
                shadowColor: const Color(0x664F46E5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ==========================================
            // 4. WIDGET ADICIONAL: GridView (4 celdas interactivas)
            // ==========================================
            const Text(
              'Widget Adicional: GridView (4 Celdas)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: const [
                _GridItemCard(
                  icon: Icons.widgets_rounded,
                  title: 'StatefulWidget',
                  color: Color(0xFF6366F1),
                ),
                _GridItemCard(
                  icon: Icons.sync_rounded,
                  title: 'setState()',
                  color: Color(0xFF0EA5E9),
                ),
                _GridItemCard(
                  icon: Icons.layers_rounded,
                  title: 'Stack & Row',
                  color: Color(0xFF8B5CF6),
                ),
                _GridItemCard(
                  icon: Icons.grid_view_rounded,
                  title: 'GridView List',
                  color: Color(0xFF10B981),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ==========================================
            // 5. WIDGET ADICIONAL: ListView (Lista simple con iconos)
            // ==========================================
            const Text(
              'Widget Adicional: ListView (Lista de Elementos)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFFEEF2FF),
                      child: Icon(Icons.code_rounded, color: Color(0xFF4F46E5)),
                    ),
                    title: Text(
                      'Control de Versiones Git',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('Ramas: main, dev, feature/taller1'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  ),
                  Divider(height: 1, indent: 64),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFFE0F2FE),
                      child: Icon(Icons.flutter_dash_rounded, color: Color(0xFF0EA5E9)),
                    ),
                    title: Text(
                      'Gestión de Estado Base',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('Reactividad mediante setState()'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  ),
                  Divider(height: 1, indent: 64),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFFECFDF5),
                      child: Icon(Icons.check_circle_outline_rounded, color: Color(0xFF10B981)),
                    ),
                    title: Text(
                      'Notificaciones SnackBar',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('Retroalimentación dinámica al usuario'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Subwidget personalizado para las tarjetas del GridView
class _GridItemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _GridItemCard({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
