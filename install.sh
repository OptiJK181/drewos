#!/usr/bin/env bash
# ===============================================================================
#                      DREWOS AUTOMATED CONFIGURATION SCRIPT
# ===============================================================================
# Repositorio Oficial: DrewOS Auto-Installer & System Optimizer
# Compatible con Arch Linux, Garuda Linux y entornos KDE Plasma 6 (Wayland)
# ===============================================================================

set -e

BOLD="\033[1m"
GREEN="\033[32m"
CYAN="\033[36m"
YELLOW="\033[33m"
RESET="\033[0m"

REAL_USER="${SUDO_USER:-$USER}"
USER_HOME=$(eval echo "~$REAL_USER")

echo -e "${CYAN}${BOLD}"
echo "  ____  ____  ________  _  ____  ____  "
echo " /  _ \/  __\/  __/ \  //\/  _ \/ ___\ "
echo " | | \||  \/||  \  | | |||| / \|    \ "
echo " | |_/||    /|  /_ | |/\/\/\ \_/|\___ |"
echo " \____/\_/\_\\____\\_/\_/  \____/\____/ "
echo "                                        "
echo "       OFFICIAL AUTO-INSTALLER          "
echo -e "${RESET}"

# Solicitar permisos sudo al inicio
echo -e "${YELLOW}[1/7] Solicitando permisos sudo para la configuración del sistema...${RESET}"
sudo -v

# Mantener sudo activo mientras se ejecuta el script
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# -------------------------------------------------------------------------------
# 1. BRANDING VISUAL DREWOS
# -------------------------------------------------------------------------------
echo -e "${GREEN}[2/7] Aplicando branding visual DrewOS (os-release, GRUB, Fastfetch)...${RESET}"

sudo rm -f /etc/os-release
sudo bash -c 'cat << "EOF" > /etc/os-release
NAME="DrewOS"
PRETTY_NAME="DrewOS"
ID=garuda
ID_LIKE=arch
BUILD_ID=rolling
ANSI_COLOR="38;2;23;147;209"
HOME_URL="https://garudalinux.org/"
DOCUMENTATION_URL="https://wiki.garudalinux.org/"
SUPPORT_URL="https://forum.garudalinux.org/"
BUG_REPORT_URL="https://gitlab.com/groups/garuda-linux/"
PRIVACY_POLICY_URL="https://terms.archlinux.org/docs/privacy-policy/"
LOGO=garudalinux
EOF'

sudo bash -c 'cat << "EOF" > /etc/lsb-release
DISTRIB_ID=DrewOS
DISTRIB_RELEASE=Soaring
DISTRIB_DESCRIPTION="DrewOS"
DISTRIB_CODENAME="Broadwing"
EOF'

if [ -f /etc/default/grub ]; then
  sudo sed -i 's/GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="DrewOS"/' /etc/default/grub
  sudo grub-mkconfig -o /boot/grub/grub.cfg 2>/dev/null || true
fi

# Configuración Fastfetch
sudo -u "$REAL_USER" mkdir -p "$USER_HOME/.config/fastfetch"
sudo -u "$REAL_USER" bash -c "cat << 'EOF' > '$USER_HOME/.config/fastfetch/config.jsonc'
{
    \"\$schema\": \"https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json\",
    \"logo\": {
        \"source\": \"arch_small\",
        \"type\": \"small\",
        \"padding\": {
            \"top\": 1,
            \"left\": 1,
            \"right\": 2
        }
    },
    \"modules\": [
        \"title\",
        \"separator\",
        \"os\",
        \"host\",
        \"kernel\",
        \"uptime\",
        \"packages\",
        \"shell\",
        \"display\",
        \"de\",
        \"wm\",
        \"terminal\",
        \"cpu\",
        \"gpu\",
        \"memory\",
        \"disk\",
        \"battery\",
        \"break\",
        \"colors\"
    ]
}
EOF"

# Hook en Fish shell si existe
if [ -d "$USER_HOME/.config/fish" ]; then
  if ! grep -q "fastfetch --logo arch_small" "$USER_HOME/.config/fish/config.fish" 2>/dev/null; then
    echo -e "\n# DrewOS Fastfetch\nfastfetch --logo arch_small" >> "$USER_HOME/.config/fish/config.fish"
  fi
fi

# -------------------------------------------------------------------------------
# 2. INSTALACIÓN DE PAQUETES Y SERVICIOS BASE
# -------------------------------------------------------------------------------
echo -e "${GREEN}[3/7] Instalando paquetes y activando servicios de optimización...${RESET}"
sudo pacman -S --needed --noconfirm fastfetch libva-utils ananicy-cpp gamemode pacman-contrib 2>/dev/null || true

sudo systemctl enable --now ananicy-cpp 2>/dev/null || true
sudo systemctl enable --now fstrim.timer 2>/dev/null || true
sudo systemctl enable --now paccache.timer 2>/dev/null || true

# Desactivar servicios innecesarios (bloat)
sudo systemctl disable --now ModemManager.service 2>/dev/null || true
if command -v balooctl6 &>/dev/null; then
  sudo -u "$REAL_USER" balooctl6 disable 2>/dev/null || true
fi

# -------------------------------------------------------------------------------
# 3. ENTORNO GLOBAL WAYLAND Y ACELERACIÓN GPU ELECTRON / FLATPAK
# -------------------------------------------------------------------------------
echo -e "${GREEN}[4/7] Configurando Wayland nativo y aceleración por GPU Intel (VA-API)...${RESET}"

sudo -u "$REAL_USER" mkdir -p "$USER_HOME/.config/environment.d"
sudo -u "$REAL_USER" bash -c "cat << 'EOF' > '$USER_HOME/.config/environment.d/wayland.conf'
ELECTRON_OZONE_PLATFORM_HINT=auto
LIBVA_DRIVER_NAME=iHD
VDPAU_DRIVER=va_gl
QT_QPA_PLATFORM=wayland;xcb
EOF"

if ! grep -q "ELECTRON_OZONE_PLATFORM_HINT" /etc/environment 2>/dev/null; then
  sudo bash -c 'cat << "EOF" >> /etc/environment
ELECTRON_OZONE_PLATFORM_HINT=auto
ENABLE_WAYLAND_IME=1
LIBVA_DRIVER_NAME=iHD
VDPAU_DRIVER=va_gl
QT_QPA_PLATFORM=wayland;xcb
EOF'
fi

# Banderas de renderizado para Electron y Vesktop
sudo -u "$REAL_USER" mkdir -p "$USER_HOME/.config"
sudo -u "$REAL_USER" bash -c "cat << 'EOF' > '$USER_HOME/.config/vesktop-flags.conf'
--enable-features=UseOzonePlatform,WaylandWindowDecorations
--ozone-platform=wayland
--enable-gpu-rasterization
--enable-zero-copy
--ignore-gpu-blocklist
EOF"

sudo -u "$REAL_USER" bash -c "cat << 'EOF' > '$USER_HOME/.config/electron-flags.conf'
--enable-features=UseOzonePlatform,WaylandWindowDecorations
--ozone-platform=wayland
--enable-gpu-rasterization
--enable-zero-copy
--ignore-gpu-blocklist
EOF"

# Vesktop Settings
sudo -u "$REAL_USER" mkdir -p "$USER_HOME/.config/vesktop"
sudo -u "$REAL_USER" bash -c "cat << 'EOF' > '$USER_HOME/.config/vesktop/settings.json'
{
  \"hardwareAcceleration\": true
}
EOF"

# Spotify Flatpak Flags
sudo -u "$REAL_USER" mkdir -p "$USER_HOME/.var/app/com.spotify.Client/config"
sudo -u "$REAL_USER" bash -c "cat << 'EOF' > '$USER_HOME/.var/app/com.spotify.Client/config/spotify-flags.conf'
--enable-features=UseOzonePlatform,WaylandWindowDecorations
--ozone-platform=wayland
--enable-gpu-rasterization
--enable-zero-copy
--ignore-gpu-blocklist
EOF"

if command -v flatpak &>/dev/null; then
  sudo -u "$REAL_USER" flatpak override --user --env=ELECTRON_OZONE_PLATFORM_HINT=auto com.spotify.Client 2>/dev/null || true
fi

# -------------------------------------------------------------------------------
# 4. CONFIGURACIÓN DE SPICETIFY (SPOTIFY THEMES)
# -------------------------------------------------------------------------------
echo -e "${GREEN}[5/7] Configurando Spicetify para Spotify...${RESET}"
if command -v spicetify &>/dev/null; then
  sudo -u "$REAL_USER" spicetify config overwrite_assets 1 inject_css 1 replace_colors 1 inject_theme_js 1 2>/dev/null || true
  sudo -u "$REAL_USER" spicetify apply 2>/dev/null || true
fi

# -------------------------------------------------------------------------------
# 5. OPTIMIZACIÓN MÁXIMA DE WI-FI 6 E INTERNET (GOOGLE BBR)
# -------------------------------------------------------------------------------
echo -e "${GREEN}[6/7] Optimizando Wi-Fi (Power Save OFF) y activando Google BBR TCP...${RESET}"

# Desactivar Power Save en NetworkManager
sudo mkdir -p /etc/NetworkManager/conf.d
sudo bash -c 'cat << "EOF" > /etc/NetworkManager/conf.d/default-wifi-powersave-off.conf
[connection]
wifi.powersave = 2
EOF'

# Módulo Intel iwlwifi sin ahorro de energía
sudo bash -c 'cat << "EOF" > /etc/modprobe.d/iwlwifi.conf
options iwlwifi power_save=0 uapsd_disable=1 amsdu_size=3
EOF'

# Google BBR & Búferes TCP
sudo bash -c 'cat << "EOF" > /etc/sysctl.d/99-network-performance.conf
# Enable Google BBR TCP congestion control & FQ
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr

# Increase TCP Window Sizes & Max Buffers for High-Speed Wi-Fi / Fiber
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216

# TCP Fast Open & Latency Optimization
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_slow_start_afteridle = 0
net.ipv4.tcp_mtu_probing = 1
EOF'

sudo sysctl --system 2>/dev/null || true
sudo systemctl restart NetworkManager 2>/dev/null || true

# -------------------------------------------------------------------------------
# 6. CONFIGURACIÓN DE TECLADO LATAM
# -------------------------------------------------------------------------------
echo -e "${GREEN}[7/7] Estableciendo idioma de teclado en Español Latinoamérica (LATAM)...${RESET}"
sudo localectl set-keymap latam 2>/dev/null || true
sudo localectl set-x11-keymap latam 2>/dev/null || true

sudo -u "$REAL_USER" bash -c "cat << 'EOF' > '$USER_HOME/.config/kxkbrc'
[Layout]
DisplayNames=
LayoutList=latam
LayoutLoopCount=-1
Model=pc105
Options=
ResetOldOptions=false
SwitchMode=Global
Use=true
VariantList=
EOF"

echo -e "\n${CYAN}${BOLD}===============================================================================${RESET}"
echo -e "${CYAN}${BOLD}   ¡CONFIGURACIÓN DE DREWOS APLICADA CON ÉXITO A TU SISTEMA!   ${RESET}"
echo -e "${CYAN}${BOLD}===============================================================================${RESET}"
echo -e "${YELLOW}Ejecuta 'fastfetch' para ver el nuevo branding o abre una nueva terminal.${RESET}\n"
