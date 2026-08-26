#!/usr/bin/env bash
#
# Sync dotfiles between this repo and the live system.
#
#   ./update.sh              push configs from this system into the repo, commit, push
#   ./update.sh deploy       write configs from the repo onto this system
#   ./update.sh list         show host directories tracked in this repo
#
# Run with -h for all options.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "$SCRIPT_DIR"

# ---------------------------------------------------------------------------
# What gets tracked. Add an entry here to start syncing another config.
# ---------------------------------------------------------------------------
declare -A CONF_PATHS=(
  [hypr]="$HOME/.config/hypr"
  [kitty]="$HOME/.config/kitty"
  [nvim]="$HOME/.config/nvim"
  [waybar]="$HOME/.config/waybar"
  [.bashrc]="$HOME/.bashrc"
  [.zshrc]="$HOME/.zshrc"
)

# ---------------------------------------------------------------------------
# Output helpers
# ---------------------------------------------------------------------------
c_reset='\033[0m'; c_red='\033[0;31m'; c_green='\033[0;32m'
c_yellow='\033[0;33m'; c_blue='\033[0;34m'; c_bold='\033[1m'

info()  { printf '%b==>%b %s\n' "$c_blue" "$c_reset" "$*"; }
ok()    { printf '  %b+%b %s\n' "$c_green" "$c_reset" "$*"; }
skip()  { printf '  %b-%b %s\n' "$c_yellow" "$c_reset" "$*"; }
err()   { printf '%b✗%b %s\n' "$c_red" "$c_reset" "$*" >&2; }

usage() {
  cat <<EOF
Usage: ./update.sh [MODE] [OPTIONS]

Modes:
  push      (default) copy live system configs into this repo, then commit & push
  deploy    copy configs from this repo onto the live system
  list      show host directories tracked in this repo

Options:
  --host=NAME    use NAME instead of the detected hostname ($(hostname))
  --only=a,b,c   only sync these configs (default: all: ${!CONF_PATHS[*]})
  --dry-run      show what would happen, change nothing
  --no-push      (push mode)   commit locally but don't push
  --no-commit    (push mode)   sync files only, skip git entirely
  --delete       (deploy mode) also remove system files not present in the repo
  -h, --help     show this help
EOF
}

# ---------------------------------------------------------------------------
# Args
# ---------------------------------------------------------------------------
mode="push"
host="$(hostname)"
only=""
dry_run=0
do_push=1
do_commit=1
do_delete=0

if [[ $# -gt 0 && "$1" != --* && "$1" != -h ]]; then
  mode="$1"; shift
fi

for arg in "$@"; do
  case "$arg" in
    --host=*)   host="${arg#--host=}" ;;
    --only=*)   only="${arg#--only=}" ;;
    --dry-run)  dry_run=1 ;;
    --no-push)  do_push=0 ;;
    --no-commit) do_commit=0; do_push=0 ;;
    --delete)   do_delete=1 ;;
    -h|--help)  usage; exit 0 ;;
    *) err "unknown option: $arg"; usage; exit 1 ;;
  esac
done

case "$mode" in push|deploy|list) ;; *) err "unknown mode: $mode"; usage; exit 1 ;; esac

configs=("${!CONF_PATHS[@]}")
if [[ -n "$only" ]]; then
  IFS=',' read -ra configs <<< "$only"
  for c in "${configs[@]}"; do
    [[ -v "CONF_PATHS[$c]" ]] || { err "unknown config: $c (known: ${!CONF_PATHS[*]})"; exit 1; }
  done
fi

# ---------------------------------------------------------------------------
# list mode
# ---------------------------------------------------------------------------
if [[ "$mode" == "list" ]]; then
  info "host directories in this repo:"
  for d in */; do
    d="${d%/}"
    [[ "$d" == .* ]] && continue
    if [[ "$d" == "$host" ]]; then
      printf '  %b%b* %s%b\n' "$c_bold" "$c_green" "$d" "$c_reset"
    else
      printf '    %s\n' "$d"
    fi
  done
  exit 0
fi

host_dir="$SCRIPT_DIR/$host"

if [[ "$mode" == "deploy" && ! -d "$host_dir" ]]; then
  err "no '$host' directory in this repo. Available: $(ls -d */ 2>/dev/null | tr -d / | paste -sd, -)"
  exit 1
fi

# ---------------------------------------------------------------------------
# Sync engine: prefers rsync (incremental, supports --delete), falls back
# to cp -a for directories (no delete propagation) if rsync isn't installed.
# rsync is invoked with trailing slashes on both sides so directory *contents*
# are synced in place -- this is what the old `cp -r` version got wrong, and
# why the repo used to grow host/config/config/... nesting on every run.
# ---------------------------------------------------------------------------
have_rsync=0
command -v rsync >/dev/null 2>&1 && have_rsync=1
warned_no_rsync=0

sync_path() {
  local src="$1" dst="$2"

  if [[ -d "$src" ]]; then
    if [[ "$have_rsync" == 1 ]]; then
      local args=(-a)
      [[ "$do_delete" == 1 ]] && args+=(--delete)
      if [[ "$dry_run" == 1 ]]; then
        rsync "${args[@]}" -n -i "$src/" "$dst/" | sed 's/^/      /'
      else
        mkdir -p "$dst"
        rsync "${args[@]}" "$src/" "$dst/"
      fi
    else
      if [[ "$warned_no_rsync" == 0 ]]; then
        skip "rsync not found, falling back to cp (no stale-file cleanup; install rsync for best results)"
        warned_no_rsync=1
      fi
      [[ "$dry_run" == 1 ]] && { echo "      cp -a $src/. $dst/"; return; }
      mkdir -p "$dst"
      cp -a "$src/." "$dst/"
    fi
  elif [[ -f "$src" ]]; then
    [[ "$dry_run" == 1 ]] && { echo "      cp $src -> $dst"; return; }
    mkdir -p "$(dirname "$dst")"
    cp -a "$src" "$dst"
  else
    return 1
  fi
}

# ---------------------------------------------------------------------------
# push: system -> repo
# ---------------------------------------------------------------------------
run_push() {
  info "push: syncing $host's live configs into $host_dir/ $([[ $dry_run == 1 ]] && echo '(dry run)')"
  mkdir -p "$host_dir"

  for name in "${configs[@]}"; do
    local src="${CONF_PATHS[$name]}"
    local dst="$host_dir/$name"
    if sync_path "$src" "$dst"; then
      ok "$name"
    else
      skip "$name (not found at $src)"
    fi
  done

  [[ "$do_commit" == 0 ]] && { info "skipping git (--no-commit)"; return; }

  if [[ "$dry_run" == 1 ]]; then
    info "dry run: skipping git add/commit/push"
    return
  fi

  git add -- "$host/"

  if git diff --cached --quiet -- "$host/"; then
    info "no changes for $host, nothing to commit"
    return
  fi

  local changed
  changed=$(git diff --cached --name-only -- "$host/" \
    | sed "s#^$host/##" | cut -d/ -f1 | sort -u | paste -sd, -)
  local msg="update $host: $changed"

  git commit -m "$msg"
  ok "committed: $msg"

  if [[ "$do_push" == 1 ]]; then
    git push origin "$(git rev-parse --abbrev-ref HEAD)"
    ok "pushed"
  else
    info "skipping push (--no-push)"
  fi
}

# ---------------------------------------------------------------------------
# deploy: repo -> system
# ---------------------------------------------------------------------------
run_deploy() {
  info "deploy: writing $host_dir/ onto this system $([[ $dry_run == 1 ]] && echo '(dry run)')"
  [[ "$do_delete" == 1 ]] && info "  (--delete: removing system files absent from the repo)"

  for name in "${configs[@]}"; do
    local src="$host_dir/$name"
    local dst="${CONF_PATHS[$name]}"
    if sync_path "$src" "$dst"; then
      ok "$name"
    else
      skip "$name (not tracked for $host)"
    fi
  done
}

case "$mode" in
  push)   run_push ;;
  deploy) run_deploy ;;
esac
