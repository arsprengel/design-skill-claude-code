#!/usr/bin/env bash
# Instalador da skill de design para o Claude Code (Linux / Mac / WSL).
set -euo pipefail

# pasta onde este script esta
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${HOME}/.claude"

echo "==> Instalando a skill de design no Claude Code"
echo "    Origem : ${HERE}"
echo "    Destino: ${DEST}"
echo ""

mkdir -p "${DEST}/skills"

backup_if_exists() {
  local target="$1"
  if [ -e "${target}" ]; then
    local bak="${target}.backup-antigo"
    echo "    (ja existia) fazendo backup: ${target} -> ${bak}"
    rm -rf "${bak}"
    mv "${target}" "${bak}"
  fi
}

# 1. skill principal
backup_if_exists "${DEST}/skills/design-system"
cp -r "${HERE}/skills/design-system" "${DEST}/skills/design-system"
echo "  [ok] skills/design-system"

# 2. skill de motion
backup_if_exists "${DEST}/skills/design-motion-principles"
cp -r "${HERE}/skills/design-motion-principles" "${DEST}/skills/design-motion-principles"
echo "  [ok] skills/design-motion-principles"

# 3. biblioteca de design systems
backup_if_exists "${DEST}/design-systems"
cp -r "${HERE}/design-systems" "${DEST}/design-systems"
echo "  [ok] design-systems (60 design systems)"

echo ""
echo "==> Pronto!"
echo "    Feche e abra o Claude Code de novo, e digite  /design"
echo "    (Leia o README.md pra requisitos: Node.js e MCP do Playwright.)"
