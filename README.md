# Proyecto de Automatización (Appium + Ruby + Cucumber)

Este proyecto automatiza flujos de prueba en la aplicación de **Mercado Libre para Android**, utilizando **Appium**, **Ruby** y **Cucumber**.

---

## Pre-requisitos

Antes de empezar, asegúrate de tener instalado el siguiente software:

- **Ruby** (preferiblemente v3.0+)
- **Bundler** (manejador de gemas de Ruby)
- **Bash**

```bash
gem install bundler
```

- **Node.js** (v18+)
- **Appium 2.0 (servidor)**

```bash
npm install -g appium@next
```

- **Driver UiAutomator2 (para Android)**

```bash
appium driver install uiautomator2
```

- **Android Studio** (para el Android SDK)

### Variables de Entorno de Android

Asegúrate de tener `ANDROID_HOME` (o `ANDROID_SDK_ROOT`) configurado en tu archivo `.zshrc` o `.bash_profile`.

Ejemplo:

```bash
export ANDROID_HOME="/Users/[tu_usuario]/Library/Android/sdk"
```

---

## Instalación del Proyecto

1. Abre una terminal y navega a la carpeta del proyecto (`pruebaAndroid`).
2. Instala todas las dependencias (gemas) del proyecto:

```bash
bundle install
```

---

## Cómo Ejecutar las Pruebas

La ejecución requiere **2 terminales abiertas al mismo tiempo**.

---

### Prepara el Dispositivo

1. Conecta tu dispositivo físico Android vía USB.
2. Activa las _Opciones para desarrolladores_ y la _Depuración por USB_ en el dispositivo.
3. Verifica que tu dispositivo esté conectado ejecutando:

```bash
adb devices
```

Deberías ver algo como:

```
815e0748	device
```

---

### (Terminal 1) Inicia el Servidor Appium

Este proyecto está configurado para conectarse al **puerto 8200**.

Abre tu primera terminal e inicia el servidor Appium:

```bash
appium --port 8200
```

> No cierres esta terminal.

---

### (Terminal 2) Ejecuta las Pruebas

Abre una nueva terminal, navega al proyecto (`~/Desktop/pruebaAndroid`) y ejecuta:

```bash
bundle exec cucumber features/meli.feature
```

Para ver más detalles durante la ejecución (como los `puts`), usa la opción `--verbose`:

```bash
bundle exec cucumber features/meli.feature --verbose
```

---

## Configuración

### Cambiar el Dispositivo

Si tu dispositivo cambia, debes actualizar su **ID** (el que obtienes con `adb devices`) en el archivo de configuración.

Archivo: `features/support/env.rb`

Línea a cambiar:

```ruby
"appium:options": {
  deviceName: "815e0748", # <-- CAMBIA ESTE VALOR
  # ...
}
```

---

### Ejecutar en iOS

El proyecto también puede ejecutarse en **iOS** (si se configuran las _capabilities_ en `env.rb`).

Para ejecutar las pruebas en iOS, usa la variable de entorno `PLATFORM`:

```bash
PLATFORM=ios bundle exec cucumber features/meli.feature
```

---
