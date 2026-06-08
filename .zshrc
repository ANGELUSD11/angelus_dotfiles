# Configuración del Historial de Zsh
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt inc_append_history
setopt share_history

# ==========================================
# Sistema de Autocompletado con Tabulador
# ==========================================
# 1. Cargar el sistema base de Zsh
autoload -Uz compinit
compinit

# 2. Activar el menú interactivo para navegar con Tab/Flechas
zstyle ':completion:*' menu select

# 3. Hacer que el autocompletado no distinga entre mayúsculas y minúsculas
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# 4. Colorear el menú igual que el comando 'ls'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# pnpm
export PNPM_HOME="/home/angelus/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# Pi
export PATH="/home/angelus/.local/share/mise/installs/node/26.2.0/bin:$PATH"

# Historial en tiempo real y compartido
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init - zsh)"

# Inicialización del Prompt (Siempre al final)
eval "$(starship init zsh)"

. "$HOME/.local/share/../bin/env"
