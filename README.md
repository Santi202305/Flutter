# 📱 Repositorio de Desarrollo de Aplicaciones Móviles - Flutter

Bienvenido al repositorio oficial del curso de **Desarrollo de Aplicaciones Móviles**. En este repositorio se integran todos los talleres y proyectos desarrollados utilizando la metodología **GitFlow** con un único repositorio centralizado.

---

## 👨‍💻 Datos del Estudiante
- **Nombre Completo:** Santiago Morales
- **Asignatura:** Desarrollo de Aplicaciones Móviles
- **Repositorio Público:** [https://github.com/Santi202305/Flutter.git](https://github.com/Santi202305/Flutter.git)

---

## 🚀 Estructura del Repositorio y Ramas (GitFlow)

- **`main`**: Rama de producción estable.
- **`dev`**: Rama principal de desarrollo e integración continua.
- **`feature/taller1`**: Rama del Taller 1 (integrada a `dev` y `main`).
- **`feature/taller_segundo_plano`**: Rama del Taller 2 (Asincronía, Timers e Isolates).
- **`feature/app_distribution`**: Rama del Taller de Distribución de Apps con Firebase App Distribution.

```text
  main (producción) ◄── PR #2 ── dev (desarrollo) ◄── PR #1 ── feature/app_distribution
```

---

## ⚙️ Taller 2: Asincronía con Future, Timer e Isolates (Procesamiento en Segundo Plano)

### 📌 Descripción
Desarrollo de una aplicación Flutter demostrativa para el manejo de tareas asíncronas y multihilo en segundo plano:
1. **Asincronía con `Future` y `async`/`await`:** Petición simulada de red con latencia de 2.5s, manejando los estados de *Cargando...*, *Éxito* y *Error*, imprimiendo el orden de ejecución en consola.
2. **Cronómetro con `Timer`:** Marcador digital de precisión con actualización cada 100 ms, botones (*Iniciar*, *Pausar*, *Reanudar*, *Reiniciar*) y cancelación limpia de recursos en `dispose()`.
3. **Multithreading con `Isolate`:** Ejecución de cálculos pesados CPU-bound (suma de primos hasta 30 millones) en un hilo secundario con `Isolate.spawn` y paso de mensajes mediante `ReceivePort`/`SendPort`, garantizando que la UI permanezca a 60 FPS sin congelarse.

---

### 💡 Guía Teórica: Cuándo Usar Cada Concepto

| Mecanismo | ¿Cuándo Usarlo? | Caso de Uso Típico | Hilo de Ejecución |
| :--- | :--- | :--- | :--- |
| **`Future`** | Operación asíncrona I/O que retornará un único valor o error en el futuro. | Consultas HTTP a APIs REST, lecturas/escrituras en BD local, SharedPreferences. | Hilo Principal (Event Loop) |
| **`async` / `await`** | Sintaxis declarativa para consumir `Futures` de forma secuencial y legible. | Esperar la respuesta de una API antes de actualizar el estado con `setState()`. | Hilo Principal (Event Loop) |
| **`Timer`** | Programación de tareas temporizadas diferidas o repetitivas a intervalos regulares. | Cronómetros, cuentas regresivas, animaciones de pulso, autoguardado periódico. | Hilo Principal (Event Loop) |
| **`Isolate`** | Tareas intensivas en CPU (CPU-bound) que requieren millones de operaciones lógicas. | Procesamiento/compresión de imágenes, cifrado criptográfico, parsing de JSON gigante. | **Hilo Secundario (Nativo CPU)** |

---

### 📐 Flujo de Pantallas y Arquitectura de Taller 2

```text
               ┌──────────────────────────────────────────────┐
               │    MainNavigationContainer (NavigationBar)   │
               └──────────────────────┬───────────────────────┘
                                      │
        ┌─────────────────────────────┼─────────────────────────────┐
        ▼                             ▼                             ▼
 ┌──────────────┐              ┌──────────────┐              ┌──────────────┐
 │ FutureScreen │              │ TimerScreen  │              │IsolateScreen │
 └──────┬───────┘              └──────┬───────┘              └──────┬───────┘
        │                             │                             │
        ▼                             ▼                             ▼
┌──────────────┐              ┌──────────────┐              ┌──────────────┐
│FutureService │              │Timer.periodic│              │IsolateService│
│(Future.delay)│              │(cancel in    │              │(Isolate.spawn│
│ 2.5s delay   │              │ dispose())   │              │ Receive/Send)│
└──────────────┘              └──────────────┘              └──────────────┘
```

---

### 📸 Evidencias del Taller 2 (HD Nativas)

#### 1. Future & async/await (Estados: Cargando / Éxito / Error)
Demostración del servicio simulado y estados de interfaz de usuario.
<img src="docs/screenshots/taller2/hd_02_future_cargando.png" alt="Future Cargando" width="100%" />
<img src="docs/screenshots/taller2/hd_03_future_exito.png" alt="Future Éxito" width="100%" />
<img src="docs/screenshots/taller2/hd_04_future_error.png" alt="Future Error" width="100%" />

---

#### 2. Timer (Cronómetro con Iniciar, Pausar, Reanudar, Reiniciar)
Marcador digital dinámico y gestión segura de memoria.
<img src="docs/screenshots/taller2/hd_05_timer_reiniciado.png" alt="Timer Reiniciado" width="100%" />
<img src="docs/screenshots/taller2/hd_06_timer_corriendo.png" alt="Timer Corriendo" width="100%" />
<img src="docs/screenshots/taller2/hd_07_timer_pausado.png" alt="Timer Pausado" width="100%" />

---

#### 3. Isolate (Procesamiento Pesado en Segundo Plano)
Cómputo en hilo nativo de CPU manteniendo animación a 60 FPS sin congelar la UI.
<img src="docs/screenshots/taller2/hd_08_isolate_estado_inicial.png" alt="Isolate Inicial" width="100%" />
<img src="docs/screenshots/taller2/hd_09_isolate_procesando.png" alt="Isolate Procesando" width="100%" />
<img src="docs/screenshots/taller2/hd_10_isolate_resultado.png" alt="Isolate Resultado" width="100%" />

---

## 🛠️ Taller 1: StatefulWidget, setState() y Control de Versiones Git

### 📌 Descripción
Construcción de una interfaz moderna y reactiva en Flutter para demostrar el manejo de estado mutable con `setState()`, notificaciones con `SnackBar`, consumo de imágenes `Asset`/`Network`, y widgets avanzados (`Container`, `Stack`, `GridView`, `ListView`).

### 📸 Evidencias del Taller 1

#### 1. Estado Inicial de la Aplicación
<img src="docs/screenshots/01_app_estado_inicial.png" alt="Estado Inicial Taller 1" width="100%" />

#### 2. Cambio de Título + SnackBar (`setState()`)
<img src="docs/screenshots/02_app_titulo_cambiado_snackbar.png" alt="Título Cambiado Taller 1" width="100%" />

#### 3. Pull Request #1: `feature/taller1` ➔ `dev` (Merged)
<img src="docs/screenshots/03_pr_feature_taller1_a_dev.png" alt="PR feature/taller1 a dev" width="100%" />

#### 4. Pull Request #2: `dev` ➔ `main` (Merged)
<img src="docs/screenshots/04_pr_dev_a_main.png" alt="PR dev a main" width="100%" />

---

## 📦 Taller: Distribución de Aplicaciones con Firebase App Distribution

### 📌 Flujo de Distribución
```text
  ┌─────────────────┐      ┌───────────────────────────┐      ┌───────────────┐      ┌─────────────────┐      ┌─────────────────┐
  │  Compilar APK   │ ───► │ Subir a Firebase Console  │ ───► │ Asignar Grupo │ ───► │  Notificación   │ ───► │  Instalación &   │
  │ (flutter build) │      │   (App Distribution)      │      │  (QA_Clase)   │      │ (Invitación)    │      │  Actualización  │
  └─────────────────┘      └───────────────────────────┘      └───────────────┘      └─────────────────┘      └─────────────────┘
```

1. **Generación del APK:** Compilación en modo release validando el `applicationId` y permisos mínimos como `INTERNET`.
2. **Registro y Carga en Firebase Console:** Creación del aplicativo Android en Firebase Console asociando el `applicationId` (`com.santi.taller2.taller2`).
3. **Gestión de Testers y Grupos:** Creación del grupo `QA_Clase` e inclusión del tester oficial (`dduran@uceva.edu.co`).
4. **Publicación y Release Notes:** Publicación del release adjuntando notas de versión detalladas y enlace de descarga.
5. **Actualización Incremental:** Despliegue de actualización pasando de versión (ej.: `1.0.0+1` a `1.0.1+2`), permitiendo a los testers recibir e instalar la nueva versión sin perder datos.

### 🏷️ Versionado y Release Notes

- **Formato de Versionado:** En `pubspec.yaml`, la propiedad `version: X.Y.Z+N` controla:
  - `versionName` (`X.Y.Z`): Nombre semántico visible para el usuario y tester (ej.: `1.0.0` y `1.0.1`).
  - `versionCode` (`N`): Entero incremental requerido por Android para validar actualizaciones de instalación (`+1`, `+2`).

- **Estructura recomendada de Release Notes:**
  ```text
  Versión: 1.0.0 (Build 1)
  Fecha: 29/10/2026
  Responsable: Santiago Morales
  Cambios incluidos:
  - Implementación inicial de la app con gestión de tareas asíncronas y segundo plano.
  - Módulos de Future, Timer e Isolate operativos.
  - Permiso de INTERNET configurado en AndroidManifest.xml.
  ```

### 🚀 Publicación y Replicación en Equipo
Para replicar el proceso de publicación:
```bash
# 1. Asegurar la versión en pubspec.yaml
# version: 1.0.0+1

# 2. Compilar APK release
cd taller2
flutter build apk --release

# 3. Ubicación del binario generado:
# taller2/build/app/outputs/flutter-apk/app-release.apk

# 4. En Firebase Console -> App Distribution:
# - Arrastrar app-release.apk
# - Seleccionar grupo QA_Clase (tester: dduran@uceva.edu.co)
# - Pegar Release Notes y presionar 'Distribuir'
```

---

## 💻 Pasos para Ejecutar (Windows / Linux / Web)

```bash
# 1. Clonar el repositorio
git clone https://github.com/Santi202305/Flutter.git

# 2. Ejecutar Taller 2 (Asincronía e Isolates)
cd Flutter/taller2
flutter pub get
flutter run -d linux      # Linux Desktop
flutter run -d windows    # Windows Desktop
flutter run -d chrome     # Navegador Web

# 3. Ejecutar Taller 1 (StatefulWidget)
cd ../taller1
flutter pub get
flutter run -d linux
```
