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
        echo -e "${GREEN}[+] Instalando paquetes base de Hyprland + hyprlang2lua (Lua config, ready for 0.57+)...${RESET}"
        sudo pacman -S --needed --noconfirm hyprland xdg-desktop-portal-hyprland hyprpaper hyprlock hypridle waybar wofi kitty hyprlang2lua 2>/dev/null || true

        echo -e "${CYAN}¿Deseas ejecutar de inmediato el instalador oficial de Dotfiles de ilyamiro? [s/N]: ${RESET}\c"
        read -r response_ilyamiro < /dev/tty || true
        if [[ "$response_ilyamiro" =~ ^[SsYy]$ ]]; then
            echo -e "${GREEN}[+] Ejecutando instalador oficial de ilyamiro (imperative-dots) EN VIVO...${RESET}"
            sudo -u "$REAL_USER" bash -c "$(curl -fsSL https://raw.githubusercontent.com/ilyamiro/imperative-dots/master/install.sh)" || true
        else
            echo -e "${GREEN}[+] Aplicando configuración DrewOS en formato Lua (compatible Hyprland 0.57+)...${RESET}"
            sudo -u "$REAL_USER" mkdir -p "$USER_HOME/.config/hypr"
            sudo -u "$REAL_USER" bash -c "cat << 'EOF' > '$USER_HOME/.config/hypr/hyprland.lua'
-- =============================================================================
--                     DREWOS HYPRLAND CONFIG (LUA)
--          Compatible con Hyprland 0.55+ / 0.57+ - Formato Lua nativo
-- =============================================================================

-- MONITORES
hl.monitor(\"\", \"preferred\", \"auto\", 1)

-- VARIABLES DE ENTORNO
hl.env(\"XDG_CURRENT_DESKTOP\", \"Hyprland\")
hl.env(\"XDG_SESSION_TYPE\", \"wayland\")
hl.env(\"XDG_SESSION_DESKTOP\", \"Hyprland\")
hl.env(\"QT_QPA_PLATFORM\", \"wayland;xcb\")
hl.env(\"ELECTRON_OZONE_PLATFORM_HINT\", \"auto\")
hl.env(\"LIBVA_DRIVER_NAME\", \"iHD\")

-- AUTOSTART
hl.exec_once(\"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP\")
hl.exec_once(\"systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP\")
hl.exec_once(\"waybar\")
hl.exec_once(\"hyprpaper\")
hl.exec_once(\"/usr/lib/polkit-kde-authentication-agent-1\")

-- INPUT
hl.input({
    kb_layout = \"latam\",
    follow_mouse = 1,
    sensitivity = 0,
    accel_profile = \"flat\",
    touchpad = {
        natural_scroll = true,
        tap_to_click = true,
    },
})

-- GENERAL
hl.general({
    gaps_in = 5,
    gaps_out = 10,
    border_size = 2,
    [\"col.active_border\"] = \"rgba(33ccffee) rgba(00ff99ee) 45deg\",
    [\"col.inactive_border\"] = \"rgba(595959aa)\",
    layout = \"dwindle\",
    allow_tearing = false,
    resize_on_border = true,
})

-- DECORACION
hl.decoration({
    rounding = 10,
    blur = {
        enabled = true,
        size = 5,
        passes = 2,
        vibrancy = 0.1696,
    },
    shadow = { enabled = false },
})

-- ANIMACIONES
hl.animations({
    enabled = true,
    bezier = { { \"myBezier\", 0.05, 0.9, 0.1, 1.05 } },
    animation = {
        { \"windows\",     1, 7, \"myBezier\" },
        { \"windowsOut\",  1, 7, \"default\", \"popin 80%\" },
        { \"border\",      1, 10, \"default\" },
        { \"fade\",        1, 7, \"default\" },
        { \"workspaces\",  1, 6, \"default\" },
    },
})

-- DWINDLE
hl.dwindle({ pseudotile = true, preserve_split = true })

-- MISC
hl.misc({
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    font_family = \"JetBrains Mono\",
})

-- KEYBINDINGS
local M = \"SUPER\"
hl.bind(M .. \", RETURN\", \"exec\", \"kitty\")
hl.bind(M .. \", E\",      \"exec\", \"dolphin\")
hl.bind(M .. \", R\",      \"exec\", \"wofi --show drun\")
hl.bind(M .. \", D\",      \"exec\", \"wofi --show drun\")
hl.bind(M .. \", Q\",      \"killactive\")
hl.bind(M .. \", M\",      \"exit\")
hl.bind(M .. \", V\",      \"togglefloating\")
hl.bind(M .. \", F\",      \"fullscreen\", \"0\")
hl.bind(M .. \", left\",   \"movefocus\", \"l\")
hl.bind(M .. \", right\",  \"movefocus\", \"r\")
hl.bind(M .. \", up\",     \"movefocus\", \"u\")
hl.bind(M .. \", down\",   \"movefocus\", \"d\")
for i = 1, 10 do
    local key = tostring(i == 10 and 0 or i)
    hl.bind(M .. \", \" .. key,       \"workspace\",       tostring(i))
    hl.bind(M .. \" SHIFT, \" .. key, \"movetoworkspace\", tostring(i))
end
hl.bind(M .. \", S\",           \"togglespecialworkspace\", \"magic\")
hl.bind(M .. \" SHIFT, S\",     \"movetoworkspace\",        \"special:magic\")
hl.bind(M .. \", mouse_down\",  \"workspace\", \"e+1\")
hl.bind(M .. \", mouse_up\",    \"workspace\", \"e-1\")
hl.bindm(M .. \", mouse:272\",  \"movewindow\")
hl.bindm(M .. \", mouse:273\",  \"resizewindow\")
EOF"

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
