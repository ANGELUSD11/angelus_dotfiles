#!/bin/bash
# install.sh — Instala dependencias y restaura tus configuraciones DESDE el repo.
# Correlo en la máquina nueva (Omarchy/Arch o Debian/Ubuntu) después de clonar el repo.

set -e

# El repo es la carpeta donde vive este script (no importa dónde lo clones)
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Iniciando la instalación de tu entorno de terminal desde $REPO ..."

# 0. Verificar que el repo tenga las configuraciones antes de tocar nada
for f in .zshrc .config/starship.toml .config/kitty/kitty.conf; do
    if [ ! -e "$REPO/$f" ]; then
        echo "❌ Falta $f en el repo. Corré backup.sh en tu máquina original y hacé push primero."
        exit 1
    fi
done

# 1. Detectar el gestor de paquetes e instalar dependencias base
if command -v pacman &> /dev/null; then
    echo "📦 Sistema basado en Arch (Omarchy) detectado. Instalando paquetes..."
    sudo pacman -Syu --noconfirm --needed kitty zsh curl git fzf neovim starship ttf-jetbrains-mono-nerd \
        docker docker-compose docker-buildx

    # VS Code: el build oficial de Microsoft está en AUR (Omarchy trae yay)
    if command -v yay &> /dev/null; then
        echo "💻 Instalando VS Code (AUR)..."
        yay -S --noconfirm --needed visual-studio-code-bin
    else
        echo "💻 Instalando VS Code (build open-source 'code' de los repos oficiales)..."
        sudo pacman -S --noconfirm --needed code
    fi
elif command -v apt &> /dev/null; then
    echo "📦 Sistema basado en Debian/Ubuntu detectado. Instalando paquetes..."
    sudo apt update
    sudo apt install -y kitty zsh curl git fzf neovim unzip fontconfig

    # Starship no está en apt: instalar con el script oficial
    if ! command -v starship &> /dev/null; then
        echo "⭐ Instalando Starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi

    # JetBrainsMono Nerd Font no está en apt: descargarla a las fuentes del usuario
    if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
        echo "🔤 Instalando JetBrainsMono Nerd Font..."
        mkdir -p ~/.local/share/fonts
        curl -fLo /tmp/JetBrainsMono.zip \
            https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
        unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMonoNerd
        rm /tmp/JetBrainsMono.zip
        fc-cache -f
    fi

    # Docker Engine (con el script oficial de Docker, incluye CLI y compose)
    if ! command -v docker &> /dev/null; then
        echo "🐳 Instalando Docker Engine..."
        curl -fsSL https://get.docker.com | sudo sh
    fi

    # VS Code (paquete .deb oficial de Microsoft)
    if ! command -v code &> /dev/null; then
        echo "💻 Instalando VS Code..."
        curl -fLo /tmp/vscode.deb "https://update.code.visualstudio.com/latest/linux-deb-x64/stable"
        sudo apt install -y /tmp/vscode.deb
        rm /tmp/vscode.deb
    fi
else
    echo "⚠️ No se pudo detectar pacman o apt. Instalá kitty, zsh, curl, git, fzf, starship y JetBrainsMono Nerd Font manualmente."
    exit 1
fi

# 2. Activar Docker y permitir usarlo sin sudo
echo "🐳 Activando el servicio de Docker..."
sudo systemctl enable --now docker
if ! groups "$USER" | grep -qw docker; then
    sudo usermod -aG docker "$USER"
    echo "   (Tu usuario fue agregado al grupo docker; aplica al volver a iniciar sesión.)"
fi

# 3. Descargar plugins de Zsh (autocompletado y resaltado de sintaxis)
echo "🔌 Descargando plugins de Zsh..."
mkdir -p ~/.zsh
if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi
if [ ! -d "$HOME/.zsh/zsh-syntax-highlighting" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
fi

# 4. Restaurar tus configuraciones desde el repo
echo "📂 Restaurando tus configuraciones personales..."
mkdir -p ~/.config
cp "$REPO/.zshrc" ~/
[ -f "$REPO/.bashrc" ] && cp "$REPO/.bashrc" ~/
cp "$REPO/.config/starship.toml" ~/.config/
cp -r "$REPO/.config/kitty" ~/.config/

# 5. Cambiar la shell por defecto a Zsh (pide tu contraseña)
if [ "$(basename "$SHELL")" != "zsh" ]; then
    echo "🐚 Cambiando tu shell predeterminada a Zsh..."
    chsh -s "$(which zsh)"
fi

echo ""
echo "✅ ¡Instalación completa! Cerrá la sesión y volvé a entrar para que tu terminal quede igual que la original."
