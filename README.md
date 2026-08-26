Cloud save and sync of my arch/hyprland configurations across systems (kitty, hyprland, waybar, nvim, shell rc files).

Each top-level directory (`cryosleep/`, `genesis/`, ...) mirrors one machine's configs, named after its hostname.

## update.sh

```
./update.sh              # push: copy this system's live configs into the repo, commit, push
./update.sh deploy       # deploy: write this repo's configs (for $HOSTNAME) onto the live system
./update.sh list         # show which host directories exist in the repo
```

Useful flags:

```
--host=NAME    act as a different host than $HOSTNAME (e.g. deploy genesis's configs elsewhere)
--only=a,b,c   limit to specific configs (hypr, kitty, nvim, waybar, .bashrc, .zshrc)
--dry-run      show what would happen without touching anything
--no-push      push mode: commit locally, skip the git push
--no-commit    push mode: sync files only, skip git entirely
--delete       deploy mode: also remove system files not present in the repo
-h, --help     full usage
```

Setting up a new machine: `./update.sh deploy --host=<closest-matching-host>`.

Uses `rsync` when available (incremental, supports `--delete`); falls back to `cp` otherwise.
