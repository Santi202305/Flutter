# 📱 Repositorio de Desarrollo de Aplicaciones Móviles - Flutter

Bienvenido al repositorio oficial del curso de **Desarrollo de Aplicaciones Móviles**. En este repositorio se integran todos los talleres y proyectos desarrollados utilizando la metodología **GitFlow** con un único repositorio centralizado.

---

## 👨‍💻 Datos del Estudiante
- **Nombre Completo:** Santiago
- **Asignatura:** Desarrollo de Aplicaciones Móviles
- **Repositorio:** [https://github.com/Santi202305/Flutter.git](https://github.com/Santi202305/Flutter.git)

---

## 🚀 Estructura del Repositorio y Ramas (GitFlow)

El control de versiones se administra mediante las siguientes ramas estables y de características:

- **`main`**: Rama de producción estable.
- **`dev`**: Rama principal de desarrollo e integración continua.
- **`feature/taller1`**: Rama del Taller 1 (integrada a `dev` y posteriormente a `main` vía Pull Requests).

```text
  main (producción) ◄────── (PR #2) ────── dev (desarrollo) ◄────── (PR #1) ────── feature/taller1
```

---

## 🛠️ Talleres Desarrollados

### 📌 Taller 1: StatefulWidget, setState() y Control de Versiones Git

Construcción de una interfaz moderna y reactiva en Flutter para demostrar el manejo de estado mutable con `setState()`, notificaciones con `SnackBar`, consumo de imágenes `Asset`/`Network`, y widgets avanzados (`Container`, `Stack`, `GridView`, `ListView`).

#### 📸 Evidencias Gráficas del Taller 1

| Estado Inicial (`Hola, Flutter`) | Estado Actualizado (`setState()` + SnackBar) |
| :---: | :---: |
| ![Estado Inicial](docs/screenshots/app_inicial.png) | ![Estado Actualizado](docs/screenshots/app_cambiado.png) |

#### 🔀 Evidencia de Pull Requests (GitFlow)

| PR 1: `feature/taller1` ➔ `dev` | PR 2: `dev` ➔ `main` |
| :---: | :---: |
| ![PR Taller1 a Dev](docs/screenshots/pr_feature_dev_merged.png) | ![PR Dev a Main](docs/screenshots/pr_dev_main_merged.png) |

---

## ⚙️ Pasos para Ejecutar el Proyecto

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/Santi202305/Flutter.git
   cd Flutter/taller1
   ```
2. Instalar las dependencias de Flutter:
   ```bash
   flutter pub get
   ```
3. Ejecutar la aplicación en entorno Linux o emulador:
   ```bash
   flutter run -d linux
   ```
