# 1. OMZ 核心设置
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Distinguish vi command mode (steady block) from insert mode (blinking block).
VI_MODE_SET_CURSOR=true
VI_MODE_CURSOR_NORMAL=2
VI_MODE_CURSOR_INSERT=1

# Make user-installed commands available before detecting shell integrations.
[ -r "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"
typeset -U path PATH
path=("$HOME/bin" $path)

# Initialize Homebrew before loading tools installed through it.
for brew_bin in \
    "$HOME/.linuxbrew/bin/brew" \
    "/home/linuxbrew/.linuxbrew/bin/brew" \
    "/opt/homebrew/bin/brew"; do
    if [[ -x "$brew_bin" ]]; then
        eval "$("$brew_bin" shellenv)"
        break
    fi
done

# Prefer Vim for command-line editing, with the system vi as a fallback.
if (( $+commands[vim] )); then
    export EDITOR=vim
    export VISUAL=vim
elif (( $+commands[vi] )); then
    export EDITOR=vi
    export VISUAL=vi
fi

# 2. 定义 OMZ 插件列表
plugins=(git extract web-search vi-mode)

# 3. 启动 Oh My Zsh
if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
else
    print -u2 "warning: Oh My Zsh is unavailable at $ZSH"
fi

if [ -f "$HOME/.p10k.zsh" ]; then
    source "$HOME/.p10k.zsh"
fi

# 4. 加载第三方插件
export ZSH_CUSTOM_PLUGINS="$HOME/.config/zsh/plugins"

if [ -d "$ZSH_CUSTOM_PLUGINS" ]; then
    [ -f "$ZSH_CUSTOM_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$ZSH_CUSTOM_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# 5. 加载个人别名
if [ -f "$HOME/.config/zsh/aliases.zsh" ]; then
    source "$HOME/.config/zsh/aliases.zsh"
fi

# 6. 初始化 zoxide
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
fi

# 7. 初始化 direnv
if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi

# 8. 初始化 fzf
if (( $+commands[fzf] )); then
    fzf_prefix=""
    if (( $+commands[brew] )); then
        fzf_prefix="$(brew --prefix fzf 2>/dev/null)"
    fi

    for fzf_script in \
        "$fzf_prefix/shell/key-bindings.zsh" \
        "/usr/share/fzf/key-bindings.zsh" \
        "/usr/share/doc/fzf/examples/key-bindings.zsh" \
        "$HOME/.fzf/shell/key-bindings.zsh"; do
        if [[ -r "$fzf_script" ]]; then
            source "$fzf_script"
            break
        fi
    done

    for fzf_script in \
        "$fzf_prefix/shell/completion.zsh" \
        "/usr/share/fzf/completion.zsh" \
        "/usr/share/doc/fzf/examples/completion.zsh" \
        "$HOME/.fzf/shell/completion.zsh"; do
        if [[ -r "$fzf_script" ]]; then
            source "$fzf_script"
            break
        fi
    done
fi

# 9. Initialize Atuin after fzf so Ctrl-R opens Atuin history search.
ATUIN_LOADED=0
if (( $+commands[atuin] )); then
    if atuin_init="$(atuin init zsh --disable-up-arrow)" && eval "$atuin_init"; then
        ATUIN_LOADED=1
    else
        print -u2 'warning: Atuin initialization failed; using native history search'
    fi
fi

if (( ! ATUIN_LOADED )); then
    bindkey -M emacs '^R' history-incremental-search-backward
    bindkey -M viins '^R' history-incremental-search-backward
fi
unset ATUIN_LOADED atuin_init

# Keep familiar Emacs editing keys in vi insert mode.
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^B' backward-char
bindkey -M viins '^F' forward-char
bindkey -M viins '^P' up-history
bindkey -M viins '^N' down-history
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^K' kill-line
bindkey -M viins '^D' delete-char-or-list
bindkey -M viins '^Y' yank
bindkey -M viins '^_' undo
bindkey -M viins '^[b' backward-word
bindkey -M viins '^[f' forward-word

# Edit long command lines in Vim with Ctrl-X Ctrl-E from either vi mode.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M emacs '^X^E' edit-command-line
bindkey -M viins '^X^E' edit-command-line
bindkey -M vicmd '^X^E' edit-command-line

# Keep host-specific aliases and environment variables out of chezmoi-managed files.
[ -r "$HOME/.config/zsh/local.zsh" ] && source "$HOME/.config/zsh/local.zsh"

# Syntax highlighting must be loaded after all other ZLE widgets and hooks.
[ -f "$ZSH_CUSTOM_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "$ZSH_CUSTOM_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
