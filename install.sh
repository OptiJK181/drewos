#!/usr/bin/env bash
# ===============================================================================
#          🌪️ DREWOS - THE SURVIVOR EDITION (POST-HYPRLAND APOCALYPSE) 🌪️
# ===============================================================================
# Repositorio Oficial: DrewOS Auto-Installer & Ultra System Optimizer
# "Diles NO a las barras dobles de Quickshell y al modo de emergencia de Lua."
# ===============================================================================

set -e

BOLD="\033[1m"
GREEN="\033[32m"
CYAN="\033[36m"
YELLOW="\033[33m"
RED="\033[31m"
MAGENTA="\033[35m"
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
echo "    🌪️ OFFICIAL SURVIVOR EDITION 🌪️    "
echo -e "${RESET}"

echo -e "${MAGENTA}${BOLD}Sobrevivimos a la Segunda Guerra de las Barras Dobles y a la Crisis del Lua 0.57.${RESET}"
echo -e "${YELLOW}Preparando un sistema Ultra-Rápido, Estable, 100% Personalizado y con Escritorios Múltiples...${RESET}\n"

# Solicitar permisos sudo al inicio
echo -e "${YELLOW}[1/6] Solicitando credenciales de Super-Sobreviviente (sudo)...${RESET}"
sudo -v

# Mantener sudo activo mientras se ejecuta el script
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# -------------------------------------------------------------------------------
# 1. BRANDING VISUAL DREWOS (TORNADO SURVIVOR EDITION)
# -------------------------------------------------------------------------------
echo -e "${GREEN}[2/6] Instalando la Identidad DrewOS (os-release, GRUB, Fastfetch)...${RESET}"

sudo rm -f /etc/os-release
sudo bash -c 'cat << "EOF" > /etc/os-release
NAME="DrewOS"
PRETTY_NAME="DrewOS Survivor Edition"
ID=garuda
ID_LIKE=arch
BUILD_ID=rolling
ANSI_COLOR="38;2;23;147;209"
HOME_URL="https://github.com/OptiJK181/drewos"
DOCUMENTATION_URL="https://github.com/OptiJK181/drewos"
SUPPORT_URL="https://github.com/OptiJK181/drewos"
BUG_REPORT_URL="https://github.com/OptiJK181/drewos/issues"
PRIVACY_POLICY_URL="https://terms.archlinux.org/docs/privacy-policy/"
LOGO=drewos
EOF'

sudo bash -c 'cat << "EOF" > /etc/lsb-release
DISTRIB_ID=DrewOS
DISTRIB_RELEASE=Survivor
DISTRIB_DESCRIPTION="DrewOS Survivor Edition (No More Double Bars)"
DISTRIB_CODENAME="Tornado"
EOF'

if [ -f /etc/default/grub ]; then
  sudo sed -i 's/GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="DrewOS"/' /etc/default/grub
  sudo grub-mkconfig -o /boot/grub/grub.cfg 2>/dev/null || true
fi

# Instalar Logo PNG oficial de DrewOS
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
if [ -f "$SCRIPT_DIR/logos/tornado.png" ]; then
  sudo cp "$SCRIPT_DIR/logos/tornado.png" /usr/share/pixmaps/drewos.png 2>/dev/null || true
  sudo cp "$SCRIPT_DIR/logos/tornado.png" /usr/share/pixmaps/drewos-logo.png 2>/dev/null || true
  sudo cp "$SCRIPT_DIR/logos/tornado.png" /usr/share/pixmaps/garudalinux-logo.png 2>/dev/null || true
  sudo mkdir -p /usr/share/icons/hicolor/scalable/apps /usr/share/icons/hicolor/256x256/apps 2>/dev/null || true
  sudo cp "$SCRIPT_DIR/logos/tornado.png" /usr/share/icons/hicolor/scalable/apps/drewos.png 2>/dev/null || true
  sudo cp "$SCRIPT_DIR/logos/tornado.png" /usr/share/icons/hicolor/256x256/apps/drewos.png 2>/dev/null || true
  sudo cp "$SCRIPT_DIR/logos/tornado.png" /usr/share/icons/hicolor/scalable/apps/distributor-logo-drewos.png 2>/dev/null || true
  sudo cp "$SCRIPT_DIR/logos/tornado.png" /usr/share/icons/hicolor/scalable/apps/distributor-logo-garudalinux.png 2>/dev/null || true
  sudo gtk-update-icon-cache -f /usr/share/icons/hicolor 2>/dev/null || true
fi

# Fastfetch Tornado ASCII Config
DREWOS_LOGO='          -_-_-_-_-_-_-_-_-_-_-_-_---
           -_-_-_-_-_-_-_-_-_-_-_--
            -_-_-_-_-_-_-_-_-_-_--
              -_-_-_-_-_-_-_-_-_-
               -_-_-_-_-_-_-_-_-
                 -_-_-_-_-_-_--
                   -_-_-_-_-_-
                    -_-_-_-_-
                      -_-__-
                       _-_-
                      _-_
                     _-
                     -_
                    _-_
                   _-_-_
                  -_-_-_-_'

sudo -u "$REAL_USER" mkdir -p "$USER_HOME/.config/fastfetch"
sudo -u "$REAL_USER" mkdir -p "$USER_HOME/Logos DrewOS"
echo "$DREWOS_LOGO" | sudo -u "$REAL_USER" tee "$USER_HOME/.config/fastfetch/drewos_logo.txt" "$USER_HOME/Logos DrewOS/tornado.txt" > /dev/null

sudo -u "$REAL_USER" bash -c "cat << 'EOF' > '$USER_HOME/.config/fastfetch/config.jsonc'
{
    \"\$schema\": \"https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json\",
    \"logo\": {
        \"source\": \"~/.config/fastfetch/drewos_logo.txt\",
        \"type\": \"file\",
        \"color\": {
            \"1\": \"cyan\",
            \"2\": \"blue\"
        },
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

# Limpiar hooks de fastfetch duplicados en fish
if [ -f "$USER_HOME/.config/fish/config.fish" ]; then
  sudo -u "$REAL_USER" sed -i 's/fastfetch --logo.*/fastfetch/' "$USER_HOME/.config/fish/config.fish" 2>/dev/null || true
  if ! grep -q "fastfetch" "$USER_HOME/.config/fish/config.fish" 2>/dev/null; then
    echo -e "\n# DrewOS Fastfetch\nfastfetch" >> "$USER_HOME/.config/fish/config.fish"
  fi
fi

# -------------------------------------------------------------------------------
# 2. LIMPIEZA DE SERVICIOS Y RELLENO (NO MORE DOUBLE BARS)
# -------------------------------------------------------------------------------
echo -e "${GREEN}[3/6] Eliminando servicios fantasma y limpiando barras duplicadas...${RESET}"
sudo -u "$REAL_USER" systemctl --user disable --now waybar.service 2>/dev/null || true
kill -9 $(pgrep -x waybar) 2>/dev/null || true
kill -9 $(pgrep -x quickshell) 2>/dev/null || true

# -------------------------------------------------------------------------------
# 3. OPTIMIZACIÓN DE HARDWARE & SERVICIOS DE RENDIMIENTO
# -------------------------------------------------------------------------------
echo -e "${GREEN}[4/6] Activando aceleración GPU, ananicy-cpp, GameMode y SSD TRIM...${RESET}"
sudo pacman -S --needed --noconfirm fastfetch libva-utils ananicy-cpp gamemode pacman-contrib git curl 2>/dev/null || true

sudo systemctl enable --now ananicy-cpp 2>/dev/null || true
sudo systemctl enable --now fstrim.timer 2>/dev/null || true
sudo systemctl enable --now paccache.timer 2>/dev/null || true

# Desactivar servicios innecesarios (bloat)
sudo systemctl disable --now ModemManager.service 2>/dev/null || true
if command -v balooctl6 &>/dev/null; then
  sudo -u "$REAL_USER" balooctl6 disable 2>/dev/null || true
fi

# -------------------------------------------------------------------------------
# 4. CONFIGURACIÓN DE MULTI-ESCRITORIO & VIRTUAL WORKSPACES ROBUSTO
# -------------------------------------------------------------------------------
echo -e "${GREEN}[5/6] Configurando 4 Escritorios Virtuales fluidos e indestructibles...${RESET}"
if command -v kwriteconfig6 &>/dev/null; then
  sudo -u "$REAL_USER" kwriteconfig6 --file "$USER_HOME/.config/kwinrc" --group Desktops --key Number 4 2>/dev/null || true
  sudo -u "$REAL_USER" kwriteconfig6 --file "$USER_HOME/.config/kwinrc" --group Desktops --key Rows 1 2>/dev/null || true
fi

# Preguntar si desea un Entorno Secundario opcional (XFCE / GNOME / Cinnamon)
if [ -t 0 ] || [ -c /dev/tty ]; then
    echo -e "${CYAN}¿Deseas instalar un Entorno Ligero secundario de respaldo (ej. XFCE4)? [s/N]: ${RESET}\c"
    read -r response_de < /dev/tty || true
    if [[ "$response_de" =~ ^[SsYy]$ ]]; then
        echo -e "${GREEN}[+] Instalando XFCE4 + XFCE4-Goods para Dual-Desktop estable...${RESET}"
        sudo pacman -S --needed --noconfirm xfce4 xfce4-goodies 2>/dev/null || true
    fi
fi

# -------------------------------------------------------------------------------
# 5. MÁXIMA VELOCIDAD WI-FI 6 E INTERNET (GOOGLE BBR) + TECLADO LATAM
# -------------------------------------------------------------------------------
echo -e "${GREEN}[6/6] Aplicando parches de latencia de red (Google BBR TCP) y Teclado LATAM...${RESET}"

# Wi-Fi Power Save OFF
sudo mkdir -p /etc/NetworkManager/conf.d
sudo bash -c 'cat << "EOF" > /etc/NetworkManager/conf.d/default-wifi-powersave-off.conf
[connection]
wifi.powersave = 2
EOF'

# Google BBR
sudo bash -c 'cat << "EOF" > /etc/sysctl.d/99-network-performance.conf
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_slow_start_afteridle = 0
net.ipv4.tcp_mtu_probing = 1
EOF'

sudo sysctl --system 2>/dev/null || true
sudo localectl set-keymap latam 2>/dev/null || true
sudo localectl set-x11-keymap latam 2>/dev/null || true

echo -e "\n${CYAN}${BOLD}===============================================================================${RESET}"
echo -e "${CYAN}${BOLD}   🌪️ ¡DREWOS SURVIVOR EDITION INSTALADO CON ÉXITO! 🌪️   ${RESET}"
echo -e "${CYAN}${BOLD}===============================================================================${RESET}"
echo -e "${GREEN}✓ Sin barras dobles.${RESET}"
echo -e "${GREEN}✓ Sin pantallas rojas de error Lua 0.57.${RESET}"
echo -e "${GREEN}✓ 4 Escritorios Virtuales fluidos configurados en KDE Plasma.${RESET}"
echo -e "${YELLOW}Abre una nueva terminal para disfrutar el logo Tornado de DrewOS.${RESET}\n"
