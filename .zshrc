# =============================================================================
# CONFIGURACIÓN BÁSICA DE ZSH
# =============================================================================

# Configuración del historial (Esencial para que el autocompletado aprenda)
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY        # Comparte el historial entre todas las pestañas/paneles
setopt HIST_IGNORE_ALL_DUPS # Elimina comandos duplicados del historial
setopt HIST_REDUCE_BLANKS   # Elimina espacios en blanco extra
setopt INC_APPEND_HISTORY   # Añade comandos al historial inmediatamente

# Editor por defecto para la terminal
export EDITOR="nvim"
export VISUAL="nvim"

# =============================================================================
# AUTOCOMPLETADO Y PLUGINS (Estilo Warp)
# =============================================================================

# Inicializar el sistema de autocompletado nativo (con la tecla Tab)
autoload -Uz compinit
compinit

# Autosugerencias (El texto gris predictivo basado en tu historial)
# -> Presiona 'Flecha Derecha' para aceptar la sugerencia completa
# -> Presiona 'Alt + Flecha Derecha' para aceptar palabra por palabra
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Resaltado de sintaxis (Comandos en verde si existen, rojo si hay error)
# ¡IMPORTANTE!: Este plugin siempre debe ser el último en cargarse en tu .zshrc
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# =============================================================================
# INTEGRACIONES MODERNAS
# =============================================================================

# FZF (Paleta de búsqueda interactiva)
# Permite usar Ctrl+R para buscar en el historial de forma difusa y visual
if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
else
    # Rutas alternativas comunes si instalaste fzf mediante apt, pacman, etc.
    source /usr/share/fzf/key-bindings.zsh 2>/dev/null
    source /usr/share/fzf/completion.zsh 2>/dev/null
fi

# Inicializar Starship (El prompt modular de bloques)
eval "$(starship init zsh)"

# =============================================================================
# ALIASES ÚTILES (Atajos de teclado para comandos largos)
# =============================================================================

# Sistema
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lah'
alias c='clear'

# Git
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'

# Python / Desarrollo
alias py='python3'
alias pm='python3 manage.py'
alias venv='source venv/bin/activate'
