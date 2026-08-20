#!/usr/bin/env bash
# Instalador da pilha de design para o Claude Code (Linux / Mac / WSL).
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${HOME}/.claude"

echo "==> Instalando a pilha de design no Claude Code"
echo "    Origem : ${HERE}"
echo "    Destino: ${DEST}"
echo ""

mkdir -p "${DEST}/skills"

backup_if_exists() {
  local target="$1"
  if [ -e "${target}" ] && [ ! -L "${target}" ]; then
    local bak="${target}.backup-antigo"
    echo "    (ja existia) backup: ${target} -> ${bak}"
    rm -rf "${bak}"
    mv "${target}" "${bak}"
  elif [ -L "${target}" ]; then
    rm "${target}"
  fi
}

# 1. skills deste repo
for s in design-system motion-choreography; do
  backup_if_exists "${DEST}/skills/${s}"
  cp -r "${HERE}/skills/${s}" "${DEST}/skills/${s}"
  echo "  [ok] skills/${s}"
done

# 2. biblioteca de design systems
backup_if_exists "${DEST}/design-systems"
cp -r "${HERE}/design-systems" "${DEST}/design-systems"
echo "  [ok] design-systems (60 referencias)"

# 3. skill oficial frontend-design (versao mais nova, direto do repo da Anthropic)
backup_if_exists "${DEST}/skills/frontend-design"
mkdir -p "${DEST}/skills/frontend-design"
curl -sf "https://raw.githubusercontent.com/anthropics/skills/main/skills/frontend-design/SKILL.md" -o "${DEST}/skills/frontend-design/SKILL.md"
curl -sf "https://raw.githubusercontent.com/anthropics/skills/main/skills/frontend-design/LICENSE.txt" -o "${DEST}/skills/frontend-design/LICENSE.txt" || true
echo "  [ok] skills/frontend-design (anthropics/skills)"

# 4. make-interfaces-feel-better (jakubkrehel, MIT)
backup_if_exists "${DEST}/skills/make-interfaces-feel-better"
mkdir -p "${DEST}/skills/make-interfaces-feel-better"
MIFB="https://raw.githubusercontent.com/jakubkrehel/make-interfaces-feel-better/main/skills/make-interfaces-feel-better"
for f in SKILL.md animations.md icons.md performance.md surfaces.md typography.md; do
  curl -sf "${MIFB}/${f}" -o "${DEST}/skills/make-interfaces-feel-better/${f}"
done
curl -sf "https://raw.githubusercontent.com/jakubkrehel/make-interfaces-feel-better/main/LICENSE" -o "${DEST}/skills/make-interfaces-feel-better/LICENSE" || true
echo "  [ok] skills/make-interfaces-feel-better (jakubkrehel)"

# 5. plugin impeccable (revisao/detector) - tenta via CLI, senao orienta
if command -v claude >/dev/null 2>&1; then
  claude plugin marketplace add pbakaus/impeccable >/dev/null 2>&1 || true
  if claude plugin install impeccable@impeccable >/dev/null 2>&1; then
    echo "  [ok] plugin impeccable"
  else
    echo "  [!] plugin impeccable: rode dentro do Claude Code:"
    echo "      /plugin marketplace add pbakaus/impeccable  e depois instale 'impeccable'"
  fi
else
  echo "  [!] CLI 'claude' nao encontrada. Dentro do Claude Code rode:"
  echo "      /plugin marketplace add pbakaus/impeccable  e depois instale 'impeccable'"
fi

echo ""
echo "==> Pronto. Abra uma sessao nova do Claude Code e use /design."
