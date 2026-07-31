# Zsh with chezmoi

Apply zsh config files only:

```sh
chezmoi apply ~/.zshenv ~/.config/zsh
```

Run the optional Zsh bootstrap separately:

```sh
~/.config/zsh/bootstrap-zsh.sh all
```

Bootstrap modes:

```sh
~/.config/zsh/bootstrap-zsh.sh core
~/.config/zsh/bootstrap-zsh.sh tools
~/.config/zsh/bootstrap-zsh.sh all --update
```

`core` installs `git`, `zsh`, Oh My Zsh, Powerlevel10k, and the Zsh plugins.
`tools` installs only the optional command-line tools. `all` runs both.
Existing Git repositories are only updated with `--update`.

The bootstrap detects a usable package manager in this order: system packages
with root or passwordless sudo, an already-installed Homebrew, then Nix.
It never installs a package manager itself. Missing dependencies only produce
warnings and do not stop the remaining setup.

The tools setup:

- clones `oh-my-zsh` into `~/.oh-my-zsh`
- clones zsh plugins into `~/.config/zsh/plugins`
- clones `powerlevel10k` into `~/.oh-my-zsh/custom/themes/powerlevel10k`
- tries to install `bat`, `lsd`, `tldr`, `fzf`, `zoxide`, `yazi`, `ripgrep`, `fd`, `direnv`, and `atuin`
- prints warnings if optional tool installation fails

After the theme is installed, run `p10k configure`, then run `chezmoi re-add ~/.p10k.zsh` to preserve the generated configuration.
