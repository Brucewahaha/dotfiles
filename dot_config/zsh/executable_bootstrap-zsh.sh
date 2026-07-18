#!/bin/sh

set -u

MODE="all"
UPDATE=0
SYSTEM_MANAGER=""
SYSTEM_INSTALL_AVAILABLE=0
APT_UPDATED=0

usage() {
    cat <<'EOF'
Usage: bootstrap-zsh.sh [core|tools|all] [--update]

core     Install git and zsh.
tools    Ensure git and zsh, then install the Zsh framework, plugins, and tools.
all      Run core followed by tools (default).
--update Update existing git-based Zsh dependencies.
EOF
}

can_install_system_packages() {
    if [ "$(id -u)" -eq 0 ]; then
        return 0
    fi

    command -v sudo >/dev/null 2>&1 && sudo -n true >/dev/null 2>&1
}

detect_system_manager() {
    if ! can_install_system_packages; then
        printf '%s\n' 'info: no root or passwordless sudo; skipping system package managers' >&2
        return
    fi

    if command -v apt-get >/dev/null 2>&1; then
        SYSTEM_MANAGER="apt"
    elif command -v dnf >/dev/null 2>&1; then
        SYSTEM_MANAGER="dnf"
    elif command -v pacman >/dev/null 2>&1; then
        SYSTEM_MANAGER="pacman"
    else
        return
    fi

    SYSTEM_INSTALL_AVAILABLE=1
    printf 'info: using %s for system packages\n' "$SYSTEM_MANAGER"
}

run_as_root() {
    if [ "$(id -u)" -eq 0 ]; then
        "$@"
    else
        sudo -n "$@"
    fi
}

install_system_package() {
    apt_package="$1"
    dnf_package="$2"
    pacman_package="$3"

    case "$SYSTEM_MANAGER" in
        apt)
            if [ "$APT_UPDATED" -eq 0 ]; then
                run_as_root apt-get update || return 1
                APT_UPDATED=1
            fi
            run_as_root apt-get install -y "$apt_package"
            ;;
        dnf) run_as_root dnf install -y "$dnf_package" ;;
        pacman) run_as_root pacman -S --noconfirm "$pacman_package" ;;
        *) return 1 ;;
    esac
}

install_with_brew() {
    package="$1"
    command -v brew >/dev/null 2>&1 && brew install "$package"
}

install_with_cargo() {
    package="$1"
    command -v cargo >/dev/null 2>&1 && cargo install "$package"
}

install_with_nix() {
    package="$1"
    command -v nix >/dev/null 2>&1 && nix profile install "nixpkgs#$package"
}

command_available() {
    case "$1" in
        bat) command -v bat >/dev/null 2>&1 || command -v batcat >/dev/null 2>&1 ;;
        fd) command -v fd >/dev/null 2>&1 || command -v fdfind >/dev/null 2>&1 ;;
        *) command -v "$1" >/dev/null 2>&1 ;;
    esac
}

install_dependency() {
    name="$1"
    binary="$2"
    apt_package="$3"
    dnf_package="$4"
    pacman_package="$5"
    brew_package="$6"
    cargo_package="$7"
    nix_package="$8"

    if command_available "$binary"; then
        printf 'already installed: %s\n' "$binary"
        return
    fi

    if [ "$SYSTEM_INSTALL_AVAILABLE" -eq 1 ]; then
        install_system_package "$apt_package" "$dnf_package" "$pacman_package" || true
    fi
    command_available "$binary" || install_with_brew "$brew_package" || true
    command_available "$binary" || install_with_cargo "$cargo_package" || true
    command_available "$binary" || install_with_nix "$nix_package" || true

    if command_available "$binary"; then
        printf 'installed: %s\n' "$binary"
    else
        printf 'warning: %s is unavailable; install it manually if needed\n' "$name" >&2
    fi
}

ensure_git_repo() {
    url="$1"
    dir="$2"

    if [ -d "$dir/.git" ]; then
        if [ "$UPDATE" -eq 1 ]; then
            git -C "$dir" pull --ff-only || printf 'warning: failed to update %s\n' "$dir" >&2
        else
            printf 'already present: %s\n' "$dir"
        fi
    elif [ -d "$dir" ]; then
        printf 'warning: %s exists and is not a git repository\n' "$dir" >&2
    else
        git clone "$url" "$dir" || printf 'warning: failed to clone %s\n' "$url" >&2
    fi
}

install_core() {
    install_dependency git git git git git git git git
    install_dependency zsh zsh zsh zsh zsh zsh zsh zsh
}

install_tools() {
    if command -v git >/dev/null 2>&1; then
        plugin_dir="$HOME/.config/zsh/plugins"
        omz_dir="$HOME/.oh-my-zsh"
        theme_dir="$omz_dir/custom/themes"
        if mkdir -p "$plugin_dir" "$theme_dir"; then
            ensure_git_repo https://github.com/ohmyzsh/ohmyzsh.git "$omz_dir"
            ensure_git_repo https://github.com/zsh-users/zsh-autosuggestions.git "$plugin_dir/zsh-autosuggestions"
            ensure_git_repo https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugin_dir/zsh-syntax-highlighting"
            ensure_git_repo https://github.com/romkatv/powerlevel10k.git "$theme_dir/powerlevel10k"
        else
            printf '%s\n' 'warning: unable to create Zsh plugin directories' >&2
        fi
    else
        printf '%s\n' 'warning: git is unavailable; skipping Zsh framework and plugins' >&2
    fi

    install_dependency bat bat bat bat bat bat bat bat
    install_dependency lsd lsd lsd lsd lsd lsd lsd lsd
    install_dependency tldr tldr tealdeer tealdeer tealdeer tealdeer tealdeer tealdeer
    install_dependency fzf fzf fzf fzf fzf fzf fzf fzf
    install_dependency zoxide zoxide zoxide zoxide zoxide zoxide zoxide zoxide
    install_dependency yazi yazi yazi yazi yazi yazi yazi-fm yazi
    install_dependency ripgrep rg ripgrep ripgrep ripgrep ripgrep ripgrep ripgrep
    install_dependency fd fd fd-find fd-find fd fd fd-find fd
    install_dependency direnv direnv direnv direnv direnv direnv direnv direnv
    install_dependency atuin atuin atuin atuin atuin atuin atuin atuin
}

parse_arguments() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            core|tools|all) MODE="$1" ;;
            --update) UPDATE=1 ;;
            -h|--help) usage; exit 0 ;;
            *) printf 'error: unknown argument: %s\n' "$1" >&2; usage >&2; exit 2 ;;
        esac
        shift
    done
}

main() {
    parse_arguments "$@"
    detect_system_manager

    case "$MODE" in
        core) install_core ;;
        tools) install_core; install_tools ;;
        all) install_core; install_tools ;;
    esac
}

main "$@"
