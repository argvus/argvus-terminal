#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
TERMINAL_SCRIPT="$ROOT_DIR/src/usr/bin/argvus-terminal"
SYSTEM_ROOT="$ROOT_DIR/src/usr/share/argvus/terminal"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf -- "$TEST_ROOT"' EXIT

CONFIG_HOME="$TEST_ROOT/config"
CACHE_HOME="$TEST_ROOT/cache"
BIN_DIR="$TEST_ROOT/bin"
mkdir -p "$CONFIG_HOME/argvus" "$CACHE_HOME/argvus" "$BIN_DIR"

cat > "$TEST_ROOT/bootstrap.sh" <<EOF
ARGVUS_CONFIG_HOME="$CONFIG_HOME"
ARGVUS_CACHE_HOME="$CACHE_HOME/argvus"
ARGVUS_SYSTEM_CONFIG="$ROOT_DIR/src/usr/share/argvus"
export ARGVUS_CONFIG_HOME ARGVUS_CACHE_HOME ARGVUS_SYSTEM_CONFIG
paths_cache() { printf '%s/%s\\n' "\$ARGVUS_CACHE_HOME" "\$1"; }
EOF

cat > "$BIN_DIR/kitty" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
config=''
while (($#)); do
  case "$1" in
    --config) config="$2"; shift 2 ;;
    *) shift ;;
  esac
done
[ -n "$config" ]
[ -s "$config" ]
grep -Eq '^include .*/themes/argvus-(dark-aether|dark-dracula|light-veil)/theme\.conf$' "$config"
grep -q '^active_tab_foreground ' "$config"
EOF
chmod +x "$BIN_DIR/kitty"

printf '%s\n' argvus-dark-aether > "$CONFIG_HOME/argvus/.active-theme"
export ARGVUS_BOOTSTRAP="$TEST_ROOT/bootstrap.sh"
export ARGVUS_TERMINAL_SYSTEM_CONFIG="$SYSTEM_ROOT"
export PATH="$BIN_DIR:/usr/bin:/bin"

for theme in argvus-dark-aether argvus-dark-dracula argvus-light-veil; do
  "$TERMINAL_SCRIPT" --apply "$theme"
  config="$CACHE_HOME/argvus/argvus-terminal/kitty.conf"
  grep -q "/themes/$theme/theme.conf" "$config"
done

for iteration in $(seq 1 24); do
  theme=argvus-dark-aether
  [ $((iteration % 2)) -eq 0 ] && theme=argvus-dark-dracula
  "$TERMINAL_SCRIPT" --apply "$theme" &
  "$TERMINAL_SCRIPT" --class "argvus-test-$iteration" &
done
wait

for config in "$CACHE_HOME"/argvus/argvus-terminal/*.conf; do
  [ -s "$config" ]
  if grep -q '^include[[:space:]]*$' "$config"; then
    exit 1
  fi
done

printf 'argvus-terminal runtime concurrency test passed\n'
