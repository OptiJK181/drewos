#!/usr/bin/env bash
# ===============================================================================
#                      DREWOS AUTOMATED CONFIGURATION SCRIPT
# ===============================================================================
# Repositorio Oficial: DrewOS Auto-Installer & System Optimizer
# Compatible con Arch Linux, Garuda Linux, KDE Plasma 6 (Wayland) y Hyprland
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
LOGO=drewos
EOF'

# Instalar Logo PNG de DrewOS
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
elif [ -f "$USER_HOME/Logos DrewOS/tornado.png" ]; then
  sudo cp "$USER_HOME/Logos DrewOS/tornado.png" /usr/share/pixmaps/drewos.png 2>/dev/null || true
  sudo cp "$USER_HOME/Logos DrewOS/tornado.png" /usr/share/pixmaps/drewos-logo.png 2>/dev/null || true
  sudo cp "$USER_HOME/Logos DrewOS/tornado.png" /usr/share/pixmaps/garudalinux-logo.png 2>/dev/null || true
  sudo mkdir -p /usr/share/icons/hicolor/scalable/apps /usr/share/icons/hicolor/256x256/apps 2>/dev/null || true
  sudo cp "$USER_HOME/Logos DrewOS/tornado.png" /usr/share/icons/hicolor/scalable/apps/drewos.png 2>/dev/null || true
  sudo cp "$USER_HOME/Logos DrewOS/tornado.png" /usr/share/icons/hicolor/256x256/apps/drewos.png 2>/dev/null || true
  sudo cp "$USER_HOME/Logos DrewOS/tornado.png" /usr/share/icons/hicolor/scalable/apps/distributor-logo-drewos.png 2>/dev/null || true
  sudo cp "$USER_HOME/Logos DrewOS/tornado.png" /usr/share/icons/hicolor/scalable/apps/distributor-logo-garudalinux.png 2>/dev/null || true
  sudo gtk-update-icon-cache -f /usr/share/icons/hicolor 2>/dev/null || true
fi

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

# Logo Tornado DrewOS
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

# Hook en Fish shell si existe
if [ -f "$USER_HOME/.config/fish/config.fish" ]; then
  sudo -u "$REAL_USER" sed -i 's/fastfetch --logo.*/fastfetch/' "$USER_HOME/.config/fish/config.fish" 2>/dev/null || true
  if ! grep -q "fastfetch" "$USER_HOME/.config/fish/config.fish" 2>/dev/null; then
    echo -e "\n# DrewOS Fastfetch\nfastfetch" >> "$USER_HOME/.config/fish/config.fish"
  fi
fi

# -------------------------------------------------------------------------------
# 2. INSTALACIÓN DE PAQUETES Y SERVICIOS BASE
# -------------------------------------------------------------------------------
echo -e "${GREEN}[3/7] Instalando paquetes y activando servicios de optimización...${RESET}"
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
# 3. PREGUNTA Y EJECUCIÓN INMEDIATA DE HYPRLAND / ILYAMIRO
# -------------------------------------------------------------------------------
if [ -t 0 ] || [ -c /dev/tty ]; then
    echo -e "${CYAN}¿Deseas instalar Hyprland (Dual-Desktop con KDE Plasma)? [s/N]: ${RESET}\c"
    read -r response < /dev/tty || true
    if [[ "$response" =~ ^[SsYy]$ ]]; then
        echo -e "${GREEN}[+] Instalando paquetes de Hyprland de inmediato...${RESET}"
        sudo pacman -S --needed --noconfirm hyprland xdg-desktop-portal-hyprland hyprpaper hyprlock hypridle waybar wofi kitty hyprlang2lua 2>/dev/null || true

        echo -e "${CYAN}¿Deseas ejecutar de inmediato el instalador oficial de Dotfiles de ilyamiro? [s/N]: ${RESET}\c"
        read -r response_ilyamiro < /dev/tty || true
        if [[ "$response_ilyamiro" =~ ^[SsYy]$ ]]; then
            echo -e "${GREEN}[+] Ejecutando instalador oficial de ilyamiro (imperative-dots) EN VIVO...${RESET}"
            sudo -u "$REAL_USER" bash -c "$(curl -fsSL https://raw.githubusercontent.com/ilyamiro/imperative-dots/master/install.sh)" || true
        else
            echo -e "${GREEN}[+] Aplicando configuración DrewOS en .conf y .lua (compatible Hyprland 0.56 y 0.57+)...${RESET}"
            sudo -u "$REAL_USER" mkdir -p "$USER_HOME/.config/hypr"

            # 1. ARCHIVO HYPRLAND.CONF (HYPRLAND 0.56 Y ANTERIORES)
            sudo -u "$REAL_USER" bash -c "cat << 'EOF' > '$USER_HOME/.config/hypr/hyprland.conf'
monitor=,preferred,auto,1

env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
env = QT_QPA_PLATFORM,wayland;xcb
env = ELECTRON_OZONE_PLATFORM_HINT,auto
env = LIBVA_DRIVER_NAME,iHD

exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once = waybar &
exec-once = hyprpaper &
exec-once = /usr/lib/polkit-kde-authentication-agent-1 &

input {
    kb_layout = latam
    kb_variant =
    kb_model = pc105
    follow_mouse = 1
    touchpad {
        natural_scroll = true
    }
    sensitivity = 0
}

general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)
    layout = dwindle
    allow_tearing = false
}

decoration {
    rounding = 10
    blur {
        enabled = true
        size = 5
        passes = 2
        vibrancy = 0.1696
    }
    shadow {
        enabled = false
    }
}

animations {
    enabled = true
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

dwindle {
    preserve_split = true
}

misc {
    disable_hyprland_logo = true
    disable_splash_rendering = true
    font_family = JetBrains Mono
}

\$mainMod = SUPER

bind = \$mainMod, RETURN, exec, kitty
bind = \$mainMod, Q, killactive,
bind = \$mainMod, M, exit,
bind = \$mainMod, E, exec, dolphin
bind = \$mainMod, V, togglefloating,
bind = \$mainMod, R, exec, wofi --show drun || rofi -show drun
bind = \$mainMod, D, exec, wofi --show drun || rofi -show drun
bind = \$mainMod, J, layoutmsg, togglesplit
bind = \$mainMod, left, movefocus, l
bind = \$mainMod, right, movefocus, r
bind = \$mainMod, up, movefocus, u
bind = \$mainMod, down, movefocus, d

bind = \$mainMod, 1, workspace, 1
bind = \$mainMod, 2, workspace, 2
bind = \$mainMod, 3, workspace, 3
bind = \$mainMod, 4, workspace, 4
bind = \$mainMod, 5, workspace, 5
bind = \$mainMod, 6, workspace, 6
bind = \$mainMod, 7, workspace, 7
bind = \$mainMod, 8, workspace, 8
bind = \$mainMod, 9, workspace, 9
bind = \$mainMod, 0, workspace, 10

bind = \$mainMod SHIFT, 1, movetoworkspace, 1
bind = \$mainMod SHIFT, 2, movetoworkspace, 2
bind = \$mainMod SHIFT, 3, movetoworkspace, 3
bind = \$mainMod SHIFT, 4, movetoworkspace, 4
bind = \$mainMod SHIFT, 5, movetoworkspace, 5

bindm = \$mainMod, mouse:272, movewindow
bindm = \$mainMod, mouse:273, resizewindow
EOF"

            # Eliminar hyprland.lua residual si existe para evitar que Hyprland entre en Emergency Mode
            sudo -u "$REAL_USER" rm -f "$USER_HOME/.config/hypr/hyprland.lua" 2>/dev/null || true

            sudo -u "$REAL_USER" mkdir -p "$USER_HOME/.config/waybar"
            sudo -u "$REAL_USER" bash -c "cat << 'EOF' > '$USER_HOME/.config/waybar/config.jsonc'
{
    \"layer\": \"top\",
    \"position\": \"top\",
    \"height\": 30,
    \"modules-left\": [\"hyprland/workspaces\", \"hyprland/window\"],
    \"modules-center\": [\"clock\"],
    \"modules-right\": [\"pulseaudio\", \"network\", \"cpu\", \"memory\", \"battery\", \"tray\"],
    \"hyprland/workspaces\": { \"disable-scroll\": true, \"all-outputs\": true, \"format\": \"{name}\" },
    \"clock\": { \"format\": \"🕒 {:%H:%M | %a %d %b}\" },
    \"cpu\": { \"format\": \"💻 {usage}%\" },
    \"memory\": { \"format\": \"🧠 {}%\" },
    \"network\": { \"format-wifi\": \"📶 {essid}\", \"format-ethernet\": \"🌐 Connected\", \"format-disconnected\": \"⚠️ Disconnected\" },
    \"pulseaudio\": { \"format\": \"🔊 {volume}%\" },
    \"battery\": { \"format\": \"🔋 {capacity}%\" }
}
EOF"

            sudo -u "$REAL_USER" bash -c "cat << 'EOF' > '$USER_HOME/.config/waybar/style.css'
* { border: none; font-family: 'JetBrains Mono', sans-serif; font-size: 13px; }
window#waybar { background-color: rgba(18, 18, 24, 0.85); color: #ffffff; border-bottom: 2px solid #33ccff; }
#workspaces button { padding: 0 8px; color: #888888; }
#workspaces button.active { color: #33ccff; border-bottom: 2px solid #00ff99; }
#clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray { padding: 0 10px; margin: 2px 4px; border-radius: 6px; background-color: rgba(255, 255, 255, 0.1); }
EOF"
        fi
    fi
fi

# -------------------------------------------------------------------------------
# 4. ENTORNO GLOBAL WAYLAND Y ACELERACIÓN GPU ELECTRON / FLATPAK
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
# 5. CONFIGURACIÓN DE SPICETIFY (SPOTIFY THEMES)
# -------------------------------------------------------------------------------
echo -e "${GREEN}[5/7] Configurando Spicetify para Spotify...${RESET}"
if command -v spicetify &>/dev/null; then
  sudo -u "$REAL_USER" spicetify config overwrite_assets 1 inject_css 1 replace_colors 1 inject_theme_js 1 2>/dev/null || true
  sudo -u "$REAL_USER" spicetify apply 2>/dev/null || true
fi

# -------------------------------------------------------------------------------
# 6. OPTIMIZACIÓN MÁXIMA DE WI-FI 6 E INTERNET (GOOGLE BBR)
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
# 7. CONFIGURACIÓN DE TECLADO LATAM
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
