# 🚀 DrewOS Config & Performance Suite

<div align="center">

```text
  ____  ____  ________  _  ____  ____  
 /  _ \/  __\/  __/ \  //\/  _ \/ ___\ 
 | | \||  \/||  \  | | |||| / \|    \ 
 | |_/||    /|  /_ | |/\/\/\ \_/|\___ |
 \____/\_/\_/\____/\_/\_/  \____/\____/ 
                                        
```

**Auto-instalador y suite de optimizaciones extremas para Arch Linux, Garuda Linux y KDE Plasma 6 (Wayland)**

[![OS](https://img.shields.io/badge/OS-Arch%20%7C%20Garuda%20%7C%20DrewOS-blue.svg)](https://archlinux.org)
[![Display Server](https://img.shields.io/badge/Display-Wayland%20180Hz-purple.svg)](https://wayland.freedesktop.org)
[![Network](https://img.shields.io/badge/Network-Google%20BBR%20%2B%20Wi--Fi%206-brightgreen.svg)](https://github.com/google/bbr)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

</div>

---

## ⚡ Instalación Rápida (1 Solo Comando)

Para transformar tu sistema y aplicar todas las optimizaciones automáticamente, abre tu terminal y ejecuta:

```bash
curl -sSL https://raw.githubusercontent.com/TU_USUARIO/drewos/main/install.sh | bash
```

---

## ✨ Características Principales

### 🎨 1. Personalización de Marca (DrewOS)
- Actualiza automáticamente la identidad visual en **Fastfetch**, **Información del Sistema KDE Plasma** y **GRUB Bootloader**.
- Mantiene 100% de compatibilidad interna con repositorios de Arch Linux, `pacman` y herramientas de sistema.

### 🚀 2. Wayland Nativo & Aceleración Gráfica (180 Hz)
- Fuerza el renderizado Wayland nativo (Ozone Platform) en aplicaciones Electron como **Spotify** y **Vesktop (Discord)** eliminando el lag de XWayland.
- Habilita aceleración por hardware por GPU Intel (VA-API / `iHD` driver).

### 🎵 3. Spotify + Spicetify Integration
- Configura permisos y banderas `overwrite_assets` en Spotify Flatpak.
- Habilita la tienda de temas **Spicetify Marketplace** de forma nativa.

### 🌐 4. Redes & Wi-Fi de Ultra Alta Velocidad
- **Wi-Fi Power Save OFF**: Desactiva el ahorro de energía en tarjetas Intel Wi-Fi 6 (`iwlwifi`), eliminando picos de ping (jitter).
- **Google BBR TCP**: Habilita el algoritmo de control de congestión de Google (`tcp_bbr`) con colas FQ y ventanas TCP maximizadas a 16MB.

### ⚙️ 5. CPU & Mantenimiento Autónomo
- Integra `ananicy-cpp` para priorizar dinámicamente CPU e I/O de disco hacia la ventana enfocada.
- Activa `gamemode` para maximizar frecuencias en juegos.
- Configura temporizadores automáticos de mantenimiento para SSD (`fstrim.timer`) y limpia la caché de pacman (`paccache.timer`).
- Desactiva demonios innecesarios como `ModemManager` y `Baloo` (indexador de KDE) para un arranque ultrarrápido.

---

## 📋 Requisitos
- **SO**: Arch Linux, Garuda Linux o distribuciones derivadas.
- **Entorno de Escritorio**: KDE Plasma 6 (Wayland) recomendado.
- **Permisos**: Usuario con acceso `sudo`.

---

## 🛠️ Instalación Manual

Si prefieres clonar el repositorio e inspeccionar el código antes de ejecutarlo:

```bash
git clone https://github.com/TU_USUARIO/drewos.git
cd drewos
chmod +x install.sh
./install.sh
```

---

## 📄 Licencia
Este proyecto está bajo la Licencia **MIT**. Consulta el archivo [LICENSE](LICENSE) para más detalles.
