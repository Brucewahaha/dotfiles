# --- 自动识别命令并设置别名 ---

# 1. lsd (替代 ls)
if (( $+commands[lsd] )); then
    alias ls='lsd'
    alias ll='lsd -l'
    alias la='lsd -a'
    alias lla='lsd -la'
    alias lt='lsd --tree'
else
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
fi

# 2. bat (替代 cat)
if (( $+commands[bat] )); then
    alias cat='bat --style=plain'
elif (( $+commands[batcat] )); then
    alias cat='batcat --style=plain'
fi

# 3. tldr (替代 help)
if (( $+commands[tldr] )); then
    alias help='tldr'
fi

# 4. pacman (包管理器 - 仅在 Arch Linux 系生效)
if (( $+commands[pacman] )); then
    alias p='sudo pacman -S'
    alias pu='sudo pacman -Syu'
fi

# 5. 永远可用的简单别名
alias cl='clear'
