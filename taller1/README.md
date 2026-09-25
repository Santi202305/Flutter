# 💙 Taller 1: StatefulWidget y Control de Versiones

## 👨‍💻 Datos del Estudiante
- **Nombre Completo:** Santiago
- **Asignatura:** Desarrollo de Aplicaciones Móviles
- **Repositorio:** [https://github.com/Santi202305/Flutter.git](https://github.com/Santi202305/Flutter.git)
- **Rama:** `feature/taller1`

---

## 🎯 Objetivo del Taller
Construir una pantalla básica interactiva en Flutter utilizando `StatefulWidget` para evidenciar el manejo de estado reactivo mediante `setState()`, integrando notificaciones emergentes con `SnackBar`, consumo de imágenes mediante `Image.network()` e `Image.asset()`, y la incorporación de widgets avanzados (`Container`, `Stack`, `GridView`, `ListView`).

---

## 📸 Evidencias Gráficas

### 1. Estado Inicial de la Aplicación
Muestra el título de la AppBar como *"Hola, Flutter"*, el encabezado del estudiante, la galería en `Row` y los widgets adicionales.

![Estado Inicial](docs/screenshots/app_inicial.png)

### 2. Estado Actualizado (`setState()` + SnackBar)
Tras presionar el botón *"Cambiar Título de la AppBar"*, se actualiza el título dinámicamente a *"¡Título cambiado!"* y se despliega un `SnackBar` flotante indicando *"Título actualizado"*.

![Estado Actualizado](docs/screenshots/app_cambiado.png)

---

## 🔀 Evidencia del Flujo de Git (Pull Requests)

### Integración de `feature/taller1` hacia `dev`
![PR feature a dev](docs/screenshots/pr_feature_dev_merged.png)

### Integración de `dev` hacia `main`
![PR dev a main](docs/screenshots/pr_dev_main_merged.png)

---

## ⚙️ Pasos para Ejecutar

1. Navega a la carpeta del taller:
   ```bash
   cd taller1
   ```
2. Obtén las dependencias necesarias:
   ```bash
   flutter pub get
   ```
3. Ejecuta la aplicación:
   ```bash
   flutter run -d linux
   ```
