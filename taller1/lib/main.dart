import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taller 1 Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
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
  // Estado inicial
  String _appBarTitle = 'Hola, Flutter';

  void _changeTitle() {
    setState(() {
      _appBarTitle = '¡Título cambiado!';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Título actualizado'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_appBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Text centrado con nombre
            const Center(
              child: Text(
                'Estudiante: Santiago',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Imágenes en un Row + Container (Widget adicional 1)
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Imagen Network
                  Image.network(
                    'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
                    width: 100,
                    height: 100,
                  ),
                  // Imagen Asset
                  Image.asset(
                    'assets/images/flutter_logo.png',
                    width: 100,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('Error cargando asset');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Botón con setState() y SnackBar
            Center(
              child: ElevatedButton(
                onPressed: _changeTitle,
                child: const Text('Cambiar Título'),
              ),
            ),
            const SizedBox(height: 20),

            // 4. ListView (Widget adicional 2)
            const Text(
              'Elementos adicionales:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.star),
                    title: Text('Elemento 1'),
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text('Elemento 2'),
                  ),
                  ListTile(
                    leading: Icon(Icons.thumb_up),
                    title: Text('Elemento 3'),
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
