#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════╗
# ║       AI-COMMIT — Cross-Platform Installer               ║
# ║  Supports: Linux · macOS · Windows (Git Bash / WSL)     ║
# ╚══════════════════════════════════════════════════════════╝
set -euo pipefail

# ── colours ─────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

ok()   { echo -e "${GREEN}${BOLD}✔${RESET} $*"; }
info() { echo -e "${CYAN}${BOLD}→${RESET} $*"; }
warn() { echo -e "${YELLOW}${BOLD}⚠${RESET} $*"; }
err()  { echo -e "${RED}${BOLD}✘${RESET} $*" >&2; }
die()  { err "$*"; exit 1; }

echo -e "\n${CYAN}${BOLD}╔══════════════════════════════════╗"
echo -e "║   AI-COMMIT Installer  v1.0      ║"
echo -e "╚══════════════════════════════════╝${RESET}\n"

# ── detect OS ───────────────────────────────────────────────
OS="$(uname -s 2>/dev/null || echo Windows)"
case "$OS" in
  Linux*)   PLATFORM=linux ;;
  Darwin*)  PLATFORM=mac   ;;
  MINGW*|MSYS*|CYGWIN*) PLATFORM=windows ;;
  *)        PLATFORM=unknown ;;
esac
info "Detected platform: $PLATFORM"

# ── check python ────────────────────────────────────────────
PYTHON=""
for py in python3 python; do
  if command -v "$py" &>/dev/null; then
    version=$("$py" --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
    major=$(echo "$version" | cut -d. -f1)
    minor=$(echo "$version" | cut -d. -f2)
    if [[ "$major" -ge 3 && "$minor" -ge 9 ]]; then
      PYTHON="$py"
      break
    fi
  fi
done
[[ -z "$PYTHON" ]] && die "Python 3.9+ is required. Install from https://python.org"
ok "Python: $($PYTHON --version)"

# ── install dir ─────────────────────────────────────────────
INSTALL_DIR="${HOME}/.local/bin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_SCRIPT="${SCRIPT_DIR}/bin/ai-commit"

[[ ! -f "$MAIN_SCRIPT" ]] && die "Cannot find bin/ai-commit — run from the ai-commit directory"

mkdir -p "$INSTALL_DIR"

# ── copy script ─────────────────────────────────────────────
DEST="${INSTALL_DIR}/ai-commit"
cp "$MAIN_SCRIPT" "$DEST"
chmod +x "$DEST"
ok "Script installed to: $DEST"

# ── global config dir ───────────────────────────────────────
CONFIG_DIR="${HOME}/.ai-commit"
mkdir -p "$CONFIG_DIR"

ENV_FILE="${CONFIG_DIR}/.env"
EXAMPLE_FILE="${SCRIPT_DIR}/.env.example"

if [[ ! -f "$ENV_FILE" ]]; then
  if [[ -f "$EXAMPLE_FILE" ]]; then
    cp "$EXAMPLE_FILE" "$ENV_FILE"
    ok "Config created: $ENV_FILE"
    warn "→ Edit $ENV_FILE and add your API key!"
  else
    warn "No .env.example found — create $ENV_FILE manually"
  fi
else
  warn "$ENV_FILE already exists — not overwritten"
fi

# ── add to PATH if needed ────────────────────────────────────
PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'

add_to_shell() {
  local rc_file="$1"
  if [[ -f "$rc_file" ]]; then
    if ! grep -q '.local/bin' "$rc_file" 2>/dev/null; then
      echo "" >> "$rc_file"
      echo "# ai-commit — added by installer" >> "$rc_file"
      echo "$PATH_LINE" >> "$rc_file"
      ok "Added PATH to $rc_file"
    fi
  fi
}

if [[ "$PLATFORM" == "windows" ]]; then
  add_to_shell "${HOME}/.bashrc"
else
  add_to_shell "${HOME}/.bashrc"
  add_to_shell "${HOME}/.zshrc"
  add_to_shell "${HOME}/.profile"
fi

# ── shell alias (optional convenience) ──────────────────────
ALIAS_LINE='alias gai="ai-commit"'
ALIAS_LINE2='alias gai-dry="ai-commit --dry-run"'

add_alias() {
  local rc_file="$1"
  if [[ -f "$rc_file" ]]; then
    if ! grep -q 'alias gai=' "$rc_file" 2>/dev/null; then
      echo "" >> "$rc_file"
      echo "# ai-commit aliases" >> "$rc_file"
      echo "$ALIAS_LINE"  >> "$rc_file"
      echo "$ALIAS_LINE2" >> "$rc_file"
      ok "Aliases added to $rc_file:  gai  |  gai-dry"
    fi
  fi
}

if [[ "$PLATFORM" == "windows" ]]; then
  add_alias "${HOME}/.bashrc"
else
  add_alias "${HOME}/.bashrc"
  add_alias "${HOME}/.zshrc"
fi

# ── final summary ────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "  ✅  Installation complete!"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "  ${BOLD}Next steps:${RESET}"
echo -e "  1. Edit your API key:  ${CYAN}nano ~/.ai-commit/.env${RESET}"
echo -e "  2. Reload shell:       ${CYAN}source ~/.bashrc${RESET}  (or open new terminal)"
echo -e "  3. Stage your changes: ${CYAN}git add .${RESET}"
echo -e "  4. Run:                ${CYAN}ai-commit${RESET}  (or alias ${CYAN}gai${RESET})"
echo ""
echo -e "  ${BOLD}CLI flags:${RESET}"
echo -e "  ${CYAN}ai-commit --dry-run${RESET}         → preview without committing"
echo -e "  ${CYAN}ai-commit --no-push${RESET}         → commit but don't push"
echo -e "  ${CYAN}ai-commit --provider ollama${RESET} → use local Ollama"
echo -e "  ${CYAN}ai-commit --no-quality${RESET}      → skip tests/lint"
echo ""
