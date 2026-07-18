# Dotfiles

这是使用 [chezmoi](https://www.chezmoi.io/) 管理的个人配置。

当前仓库主要包含：

- Zsh、Oh My Zsh、Powerlevel10k 和常用命令行工具配置
- Niri 和 Noctalia 配置
- Neovim 配置及插件锁定文件
- tmux 配置
- Code - OSS 用户设置和快捷键

## 首次安装前

完整安装前需要准备：

- 能正常运行的 `chezmoi`
- 一个可用的系统包管理器：`pacman`、`dnf`、`apt-get`、Nix `nix` 或 Homebrew
- `sudo`、`git` 和网络连接；Nix 用户通常不需要 `sudo`
- 可以安装系统软件的账户或 Nix profile 权限
- 一个可用的 shell；安装脚本会尝试安装 `zsh`

安装脚本不会安装系统包管理器、`sudo`、`chezmoi` 或网络环境本身。

Zsh 安装脚本会按当前环境尝试使用 Homebrew、`pacman`、`dnf`、`apt-get`、Nix 和 Cargo。它不会自动执行完整系统升级；如果某个工具依赖额外运行时，脚本会失败并在下一次 `chezmoi apply` 时重试。

### Niri

需要提前安装或确认以下程序：

- `niri`
- `noctalia-shell` 对应的 QuickShell 命令 `qs`
- `kitty`、`dolphin`
- `fcitx5`
- `xwayland-satellite`
- `playerctl`、`brightnessctl`、`wireplumber`
- `niri-switch`

这些程序目前由系统包管理器负责，不由 Zsh 安装脚本安装。

安装后用下面的命令查看显示器名称：

```sh
niri msg outputs
```

显示器、分辨率、缩放和位置配置位于：

```text
~/.config/niri/local.kdl
```

这个文件不由 chezmoi 管理，可以在不同电脑上自由修改。

### Noctalia

Noctalia 配置默认引用壁纸目录和显示器名称。部署后请检查：

```text
~/Pictures/Wallpapers
~/.face
```

Noctalia 插件配置会保留插件源和启用状态，但插件本身由 Noctalia 插件管理器下载。

### Code - OSS

当前配置路径是：

```text
~/.config/Code - OSS/User/settings.json
~/.config/Code - OSS/User/keybindings.json
```

扩展本身不由 chezmoi 安装。至少需要根据配置安装对应扩展，例如 Vim、Tokyo Night 等扩展。

### Neovim

Neovim 配置包含以下语言服务器：

- Python、Rust、Go
- C、C++
- Haskell、Clojure
- JavaScript、TypeScript
- Java、C#、Swift、Kotlin
- HTML、XML、JSON、Bash

语言服务器不会在 Neovim 启动时全部安装。只有当前系统中对应的可执行文件存在时，Neovim 才会启用该 LSP。打开缺少 LSP 的语言文件时，会提示对应的 `:MasonInstall` 命令。

常用检查命令：

```vim
:Mason
:LspInfo
:ConformInfo
:checkhealth
```

部分语言还需要系统运行时：

- JavaScript、TypeScript、HTML、JSON：Node.js 和 npm
- Go：Go toolchain
- Rust：Rust toolchain，包含 `cargo`、`rustfmt` 和 `clippy`
- Java：JDK
- C#：.NET SDK
- Swift：Swift toolchain 和 `sourcekit-lsp`

Neovim 的 formatter 和 linter 也按当前环境加载。缺少工具时不会阻止 Neovim 启动，可以在 Mason 中按需安装。

## 首次部署

从远程仓库初始化并应用：

```sh
chezmoi init --apply <repository-url>
```

如果仓库已经初始化：

```sh
chezmoi apply
```

首次完整应用会处理 chezmoi 脚本，包括：

- 安装或确认 `git` 和 `zsh`
- 安装 Zsh 使用的命令行工具
- 克隆 Oh My Zsh、Powerlevel10k 和 Zsh 插件
- 创建缺失的 `~/.config/niri/local.kdl`
- 安装 tmux 插件管理器

Neovim 插件由 Lazy.nvim 管理，语言工具由 Mason 按需管理。Neovim 的插件目录、Mason 安装目录和 Treesitter parser 不属于 chezmoi 源文件。

脚本不会覆盖已经存在的本机 `local.kdl`。

## 按需应用配置

只应用 Zsh：

```sh
chezmoi apply ~/.zshenv ~/.config/zsh
```

只应用 Niri：

```sh
chezmoi apply ~/.config/niri
```

只应用 Noctalia：

```sh
chezmoi apply ~/.config/noctalia
```

只应用 Neovim：

```sh
chezmoi apply ~/.config/nvim
```

只应用 Code - OSS：

```sh
chezmoi apply ~/.config/"Code - OSS"/User
```

应用前建议先查看变更：

```sh
chezmoi diff
```

## 常用操作

查看源目录：

```sh
chezmoi source-path
chezmoi cd
```

查看当前目标文件是否偏离源文件：

```sh
chezmoi status
chezmoi diff
```

把家目录中已经修改好的文件重新写回 chezmoi 源目录：

```sh
chezmoi re-add ~/.zshenv ~/.config/zsh/.zshrc
```

或者使用 `add`：

```sh
chezmoi add ~/.config/niri/config.kdl
```

从管理中移除文件，但保留家目录中的文件：

```sh
chezmoi forget ~/.zshenv ~/.config/zsh/.zshrc
```

从远程仓库获取更新并应用：

```sh
chezmoi update
```

更新前最好确保本地修改已经处理完，并先运行：

```sh
chezmoi diff
```

## 文件归属

### chezmoi 管理

```text
~/.zshenv
~/.config/zsh/.zshrc
~/.p10k.zsh
~/.config/zsh/core.zsh
~/.config/zsh/aliases.zsh
~/.config/niri/config.kdl
~/.config/niri/noctalia.kdl
~/.config/noctalia/
~/.config/nvim/
~/.config/Code - OSS/User/settings.json
~/.config/Code - OSS/User/keybindings.json
~/.tmux.conf
```

### 本机维护，不由 chezmoi 管理

```text
~/.config/niri/local.kdl
~/.config/zsh/local.zsh
~/.config/zsh/plugins/
~/.config/zsh/.zcompdump*
~/.config/zsh/.zsh_history
~/.local/share/nvim/
~/.local/state/nvim/
```

本机差异应优先放入这些文件，而不是直接修改 chezmoi 管理的通用配置。

## Zsh 工具

当前已经使用：

| 工具 | 用途 |
| --- | --- |
| `bat` | 带高亮和分页的 `cat` 替代品 |
| `lsd` | `ls` 替代品 |
| `yazi` | 终端文件管理器 |
| `fzf` | 模糊搜索和交互选择 |
| `zoxide` | 基于历史记录的目录跳转 |
| `tldr` | 简化版命令帮助 |
| `ripgrep` | 快速文本搜索，命令名为 `rg` |
| `fd` | 更易用的文件搜索 |
| `direnv` | 按目录加载项目环境变量 |
| `atuin` | 增强 shell 历史搜索 |

建议优先考虑：

- `ripgrep`：比 `grep` 更快，Neovim、fzf 工作流常用
- `fd`：比 `find` 更易用，常用于文件搜索
- `direnv`：进入项目目录时自动加载项目环境变量
- `atuin`：增强 shell 历史搜索；使用同步功能前要考虑隐私

### Yazi 和 Ranger

两者都是终端文件管理器，功能有明显重叠，不建议同时作为默认文件管理器安装。

- `ranger`：Python 实现，成熟、配置资料多，但当前已移除
- `yazi`：Rust 实现，速度快，预览、归档和异步操作体验更现代，当前使用 `ya` 别名启动

当前只安装和使用 Yazi，不再保留 Ranger 的默认入口。

同样不建议同时安装功能重叠的工具：

- `lsd` 和 `eza` 二选一
- Powerlevel10k 和 Starship 二选一
- Ranger 和 Yazi 二选一

## 配置检查

检查 Niri：

```sh
niri validate -c ~/.config/niri/config.kdl
```

检查 Zsh 语法：

```sh
zsh -n ~/.config/zsh/.zshrc
zsh -n ~/.config/zsh/core.zsh
zsh -n ~/.config/zsh/aliases.zsh
```

查看 chezmoi 当前管理的文件：

```sh
chezmoi managed
```
