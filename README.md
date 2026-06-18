# Dotfiles

My zsh + oh-my-zsh configuration, tracked with a bare git repository
whose work tree is `$HOME`. Files live in place, so oh-my-zsh keeps working.

## Layout

| File | Tracked | Loaded | Purpose |
|------|---------|--------|---------|
| `.zshrc` | yes | by zsh | Orchestrator: theme, plugins, sources the rest |
| `.config/zsh/custom/styling.zsh` | yes | auto by OMZ | Shared visuals / colors |
| `.config/zsh/custom/aliases.zsh` | yes | auto by OMZ | Common aliases |
| `.zshrc.local` | no | by `.zshrc`, last | Per-machine aliases / overrides |
| `.zsh_secrets` | no | by `.zshrc`, last | API keys, tokens — never committed |
| `.zsh_secrets.example` | yes | — | Template showing which secrets to fill in |

Common files in `.config/zsh/custom/` are auto-sourced by oh-my-zsh.
The two untracked files are sourced *after* OMZ, so they override the common ones,
and are listed in `.gitignore`.

## Restore on a new machine

```sh
# 1. install oh-my-zsh WITHOUT letting it overwrite .zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

# 2. clone the bare repo
git clone --bare git@github.com:davidlekve/dotfiles.git "$HOME/.dotfiles"

# 3. define the alias for this shell session
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# 4. check the tracked files out into $HOME
dotfiles checkout

# 5. silence untracked-file noise
dotfiles config --local status.showUntrackedFiles no
```

### If step 4 errors with "would be overwritten by checkout"

A default file (usually `.zshrc`) already exists. Back the conflicting ones up
and retry:

```sh
mkdir -p ~/.dotfiles-backup
dotfiles checkout 2>&1 | grep -E "^\s+\." | awk '{print $1}' \
  | xargs -I{} sh -c 'mkdir -p ~/.dotfiles-backup/$(dirname {}); mv {} ~/.dotfiles-backup/{}'
dotfiles checkout
```

## After restoring

```sh
cp ~/.zsh_secrets.example ~/.zsh_secrets   # then edit in real values
exec zsh                                   # reload
```

External plugins (zsh-autosuggestions, etc.) are not tracked — reinstall with:

```sh
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ~/.config/zsh/custom/plugins/zsh-autosuggestions
```
