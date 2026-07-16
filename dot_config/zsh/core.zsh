# 1. OMZ 核心设置
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

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

# 2. 定义 OMZ 插件列表
plugins=(git extract web-search)

# 3. 启动 Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

if [ -f "$HOME/.p10k.zsh" ]; then
    source "$HOME/.p10k.zsh"
fi

# 4. 加载第三方插件
export ZSH_CUSTOM_PLUGINS="$HOME/.config/zsh/plugins"

if [ -d "$ZSH_CUSTOM_PLUGINS" ]; then
    [ -f "$ZSH_CUSTOM_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$ZSH_CUSTOM_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [ -f "$ZSH_CUSTOM_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "$ZSH_CUSTOM_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
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

# 8. 初始化 atuin
if (( $+commands[atuin] )); then
    eval "$(atuin init zsh)"
fi

# 9. 初始化 fzf
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

[ -r "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"

# 9. 本地工具路径
export PATH="$HOME/bin/:$PATH"

# Keep host-specific aliases and environment variables out of chezmoi-managed files.
[ -r "$HOME/.config/zsh/local.zsh" ] && source "$HOME/.config/zsh/local.zsh"
