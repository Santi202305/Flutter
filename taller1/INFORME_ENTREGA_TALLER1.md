# INFORME TÉCNICO - TALLER 1: STATEFULWIDGET Y CONTROL DE VERSIONES

---

## 1. PORTADA
- **Estudiante:** Santiago
- **Código:** [Tu Código de Estudiante]
- **Asignatura:** Desarrollo de Aplicaciones Móviles
- **Nombre del Taller:** Taller 1 - Construcción de Pantalla Básica con StatefulWidget y Control de Versiones Git
- **Enlace del Repositorio:** [https://github.com/Santi202305/Flutter.git](https://github.com/Santi202305/Flutter.git)
- **Rama del Taller:** `feature/taller1`

---

## 2. OBJETIVO DEL TALLER
Construir una pantalla básica en Flutter implementando la arquitectura de un `StatefulWidget` para demostrar de manera explícita la reactividad y gestión de estado mediante el método `setState()`. Asimismo, poner en práctica las buenas prácticas profesionales de control de versiones utilizando un flujo de trabajo estructurado en Git con las ramas `main`, `dev` y `feature/taller1`.

---

## 3. EXPLICACIÓN TÉCNICA: StatefulWidget Y setState()

### ¿Qué es un StatefulWidget?
En Flutter, un `StatefulWidget` es un widget mutable cuya representación visual puede cambiar dinámicamente durante el ciclo de vida de la aplicación en respuesta a eventos del usuario, llegada de datos o cambios de configuración.

A diferencia de un `StatelessWidget` (que es inmutable y estático), un `StatefulWidget` divide su estructura en dos clases:
1. La clase widget que extiende de `StatefulWidget` (inmutable).
2. La clase estado que extiende de `State<StatefulWidget>`, la cual almacena variables mutables y gestiona el ciclo de vida de la pantalla.

### Uso e Importancia de setState()
El método `setState()` es la función fundamental que notifica al framework de Flutter que el estado interno del objeto ha cambiado. Al invocar `setState(() { ... })`:
- Se ejecuta la función anónima donde se modifican las variables de estado (en nuestro caso, `_appBarTitle`).
- Flutter marca el widget como "sucio" (*dirty*) y programa la reejecución del método `build()`.
- Se vuelve a renderizar únicamente el subárbol de widgets afectado por el cambio de estado, logrando un cambio reactivo en tiempo real en la pantalla sin recargar toda la aplicación.

#### Extracto del Código Implementado:
```dart
class _HomePageState extends State<HomePage> {
  // 1. Variable de estado inicial
  String _appBarTitle = 'Hola, Flutter';

  // 2. Método reactivo que altera el estado
  void _toggleTitle() {
    setState(() {
      if (_appBarTitle == 'Hola, Flutter') {
        _appBarTitle = '¡Título cambiado!';
      } else {
        _appBarTitle = 'Hola, Flutter';
      }
    });

    // 3. Notificación con SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 12),
            Text('Título actualizado'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
```

---

## 4. EVIDENCIA DE WIDGETS IMPLEMENTADOS

En la solución desarrollada se incorporaron los siguientes widgets clave cumpliendo con el diseño limpio y profesional:

1. **AppBar Reactivo:** Título dinámico que alterna entre *"Hola, Flutter"* y *"¡Título cambiado!"*.
2. **Text Centrado:** Muestra el nombre completo del estudiante dentro de una tarjeta con gradiente (*Header*).
3. **Imágenes en Row (`Image.network` e `Image.asset`):**
   - `Image.network()` cargando una imagen desde un servidor HTTP remoto.
   - `Image.asset()` cargando el logo local de Flutter configurado en `pubspec.yaml`.
4. **ElevatedButton.icon:** Botón estilizado que ejecuta `_toggleTitle()` y desencadena el `setState()`.
5. **SnackBar:** Notificación flotante emergente con icono que confirma la actualización del título.
6. **Widget Adicional 1 - Container & Stack:** Tarjetas con bordes redondeados, sombras dinámicas y superposición de etiquetas de texto sobre cada imagen mediante `Stack`.
7. **Widget Adicional 2 - GridView:** Rejilla de 4 celdas interactivas representando los conceptos clave del taller.
8. **Widget Adicional 3 - ListView:** Lista estilizada de elementos con `ListTile`, iconos y texto explicativo.

---

## 5. FLUJO DE TRABAJO EN GIT (GITFLOW)

Se implementó el flujo de trabajo profesional exigido:

1. **Ramas Base:**
   - `main`: Rama de producción estable.
   - `dev`: Rama de desarrollo e integración continua.
2. **Rama del Taller:**
   - `feature/taller1`: Rama de características creada a partir de `dev` para realizar el desarrollo aislado del Taller 1.

### Historial de Commits Descriptivos Realizados:
```text
* style: enhance UI design, fix asset loading, add GridView and Stack widgets
* docs: add README with instructions
* feat: implement main screen with state and additional widgets
* feat: add assets and update pubspec
* chore: flutter generate boilerplate
* docs: Initial commit
```

---

## 6. EVIDENCIAS GRÁFICAS (CAPTURAS DE PANTALLA)

> *Nota: Adjunta las capturas tomadas de la aplicación en ejecución en los espacios indicados a continuación:*

1. **Estado Inicial de la Aplicación:**
   - *Muestra el título "Hola, Flutter" en la AppBar, la tarjeta del estudiante, las imágenes y las listas.*
2. **Cambio de Título y Notificación SnackBar:**
   - *Muestra la AppBar con "¡Título cambiado!" y el SnackBar flotante de color verde en la parte inferior.*
3. **Evidencia de los Widgets Adicionales (Container, Stack, GridView, ListView):**
   - *Muestra el correcto renderizado de la galería con Stack, las 4 celdas del GridView y la lista ListView.*
4. **Evidencia del Flujo de Git:**
   - *Captura del comando `git log --graph --oneline --all` o la pantalla de Pull Requests en GitHub.*

---
