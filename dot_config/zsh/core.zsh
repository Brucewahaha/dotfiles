# 1. OMZ 核心设置
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# 2. 定义 OMZ 插件列表
plugins=(git extract web-search)

# 3. 启动 Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

if [ -f "$HOME/.p10k.zsh" ]; then
    source "$HOME/.p10k.zsh"
fi

# 4. 启动 Homebrew 和本地环境
if [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# 5. 本地工具路径
export PATH="$HOME/bin/:$PATH"

# 6. 加载第三方插件
export ZSH_CUSTOM_PLUGINS="$HOME/.config/zsh/plugins"

if [ -d "$ZSH_CUSTOM_PLUGINS" ]; then
    [ -f "$ZSH_CUSTOM_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$ZSH_CUSTOM_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [ -f "$ZSH_CUSTOM_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "$ZSH_CUSTOM_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# 7. 加载个人别名
if [ -f "$HOME/.config/zsh/aliases.zsh" ]; then
    source "$HOME/.config/zsh/aliases.zsh"
fi

# 8. 初始化 zoxide
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
fi

# 9. 初始化 fzf
if [ -f /usr/share/fzf/key-bindings.zsh ]; then
    source /usr/share/fzf/key-bindings.zsh
elif [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
elif [ -f "$HOME/.fzf/shell/key-bindings.zsh" ]; then
    source "$HOME/.fzf/shell/key-bindings.zsh"
elif [ -f "/home/linuxbrew/.linuxbrew/opt/fzf/shell/key-bindings.zsh" ]; then
    source "/home/linuxbrew/.linuxbrew/opt/fzf/shell/key-bindings.zsh"
fi

if [ -f /usr/share/fzf/completion.zsh ]; then
    source /usr/share/fzf/completion.zsh
elif [ -f /usr/share/doc/fzf/examples/completion.zsh ]; then
    source /usr/share/doc/fzf/examples/completion.zsh
elif [ -f "$HOME/.fzf/shell/completion.zsh" ]; then
    source "$HOME/.fzf/shell/completion.zsh"
elif [ -f "/home/linuxbrew/.linuxbrew/opt/fzf/shell/completion.zsh" ]; then
    source "/home/linuxbrew/.linuxbrew/opt/fzf/shell/completion.zsh"
fi
