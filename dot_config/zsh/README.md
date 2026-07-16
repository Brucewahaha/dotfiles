# Zsh with chezmoi

Apply zsh config files only:

```sh
chezmoi apply ~/.zshrc ~/.config/zsh
```

First-time setup for zsh:

```sh
chezmoi apply ~/.zshrc ~/.config/zsh
```

The first apply also runs `run_once_install_zsh.sh.tmpl`, which:

- clones `oh-my-zsh` into `~/.oh-my-zsh`
- clones zsh plugins into `~/.config/zsh/plugins`
- clones `powerlevel10k` into `~/.oh-my-zsh/custom/themes/powerlevel10k`
- tries to install `bat`, `lsd`, `tldr`, `fzf`, `zoxide`, `yazi`, `ripgrep`, `fd`, `direnv`, and `atuin`
- retries on the next `chezmoi apply` if plugin or tool installation fails
- prints warnings if optional tool installation fails

After the theme is installed, run `p10k configure` to generate your local `~/.p10k.zsh`.
