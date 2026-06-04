#!/bin/bash
# backup.sh — Copia tus configuraciones actuales AL repo.
# Correlo en esta máquina antes de hacer commit/push.

set -e

# El repo es la carpeta donde vive este script (no importa dónde lo clones)
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "💾 Guardando configuraciones en $REPO ..."

mkdir -p "$REPO/.config"

cp ~/.zshrc "$REPO/"
cp ~/.bashrc "$REPO/"
cp ~/.config/starship.toml "$REPO/.config/"

rm -rf "$REPO/.config/kitty"
cp -r ~/.config/kitty "$REPO/.config/"

echo "✅ Backup completo. Contenido del repo:"
find "$REPO" -not -path '*/.git*' -not -name '.' | sort
echo ""
echo "👉 Ahora hacé commit y push para guardarlo en remoto."
