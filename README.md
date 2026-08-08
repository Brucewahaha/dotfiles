# Dotfiles

使用 [chezmoi](https://www.chezmoi.io/) 管理的个人配置，包含 Zsh、Neovim、OpenCode、tmux、Niri、Noctalia、Fcitx5、Kitty、Zathura 和 Code - OSS。

## 目录

- [部署](#部署)
- [Zsh Bootstrap](#zsh-bootstrap)
- [Zsh](#zsh)
- [Neovim](#neovim)
- [OpenCode](#opencode)
- [Niri 与 Noctalia](#niri-与-noctalia)
- [Fcitx5 与 Kitty](#fcitx5-与-kitty)
- [Zathura](#zathura)
- [tmux](#tmux)
- [Code - OSS](#code---oss)
- [Chezmoi 命令](#chezmoi-命令)

## 部署

需要 `chezmoi`、网络和可用 shell。Zsh bootstrap 可使用系统包管理器、已安装的 Homebrew、Cargo 或 Nix；系统包安装需要 root 或 passwordless `sudo`。

```sh
chezmoi init --apply <repository-url>
```

已初始化的机器更新配置：

```sh
chezmoi update
```

首次完整 `chezmoi apply` 会运行一次初始化脚本：创建 Niri 的 `local.kdl`、安装 tmux TPM，并调用 Zsh bootstrap。它们可能下载软件或 Git 仓库；只想更新配置时应使用下方的按需 apply 命令。

## Zsh Bootstrap

Zsh 配置与安装步骤分开。先应用配置，再按需执行 bootstrap：

```sh
chezmoi apply ~/.zshenv ~/.config/zsh
~/.config/zsh/bootstrap-zsh.sh all
```

Bootstrap 模式：

```sh
~/.config/zsh/bootstrap-zsh.sh core
~/.config/zsh/bootstrap-zsh.sh tools
~/.config/zsh/bootstrap-zsh.sh all --update
```

- `core`：安装或确认 `git`、`zsh`。
- `tools`：确认 core 后，安装 Oh My Zsh、Powerlevel10k、Zsh 插件和常用命令行工具。
- `all`：依次运行 core 与 tools。
- `--update`：更新已克隆的 Zsh 依赖；默认只克隆缺失项。

安装顺序为：有权限的系统包管理器、已有 Homebrew、Cargo、Nix。缺少权限或工具时会告警，但不会中断其余步骤。

## Zsh

`~/.zshenv` 仅设置 `ZDOTDIR`，交互式配置位于 `~/.config/zsh/.zshrc`。这样非交互 shell 不会加载 Oh My Zsh、主题或插件。

本机差异放在以下位置，不要直接修改受管文件：

- `~/.config/zsh/local.zsh`：PATH、环境变量、私有别名和 API 凭据。
- `~/.p10k.zsh`：chezmoi 管理的 Powerlevel10k 配置。运行 `p10k configure` 后，用 `chezmoi re-add ~/.p10k.zsh` 保留修改。
- `~/.config/zsh/plugins/`、`.zcompdump*`、`.zsh_history`：插件与 shell 状态。

检查语法：

```sh
zsh -n ~/.zshenv ~/.config/zsh/.zshrc ~/.config/zsh/core.zsh
```

## Neovim

需要 Neovim 0.11+。应用配置后，Lazy.nvim 会管理 Neovim 插件：

```sh
chezmoi apply ~/.config/nvim
```

在 Neovim 中：

```vim
:Lazy sync
:Mason
:LspInfo
:ConformInfo
:TSInstall <language>
:checkhealth
```

- Lazy 管理插件；下载失败时使用 `:Lazy sync` 重试。
- Mason 管理 LSP、formatter、linter。缺少 LSP 时会提示对应的 `:MasonInstall` 命令，不会自动下载。
- 基础 Treesitter parser 会安装；其他语言按需使用 `:TSInstall`。
- Go、Rust、Node.js、JDK、.NET、Swift 等语言仍需要各自系统运行时。

本机的 Lazy、Mason、Treesitter 与状态数据位于 `~/.local/share/nvim/`、`~/.local/state/nvim/`。`~/.config/nvim/lazy-lock.json` 是受管文件；执行 `:Lazy update` 后，若要保留版本变更，运行：

```sh
chezmoi re-add ~/.config/nvim/lazy-lock.json
```

## OpenCode

OpenCode 配置读取 `OPENAI_API_KEY` 与 `OPENAI_API_URL`。把它们写入 `~/.config/zsh/local.zsh`，不要提交凭据。

Neovim 集成要求当前系统的原生 OpenCode 位于：

```text
Linux/macOS: ~/.opencode/bin/opencode
Windows:     ~/.opencode/bin/opencode.exe
```

安装 OpenCode 后重启 shell 与 Neovim。Neovim 中使用 `<leader>ot` 或 `:OpenCodeToggle` 打开右侧 OpenCode terminal；它与普通 Toggleterm 相互独立。

## Niri 与 Noctalia

按需应用：

```sh
chezmoi apply ~/.config/niri ~/.config/noctalia
```

Niri 依赖 `niri`、`qs`、`kitty`、`dolphin`、`fcitx5`、`xwayland-satellite`、`playerctl`、`brightnessctl`、`wireplumber` 和 `niri-switch`。显示器名称可通过以下命令查看：

```sh
niri msg outputs
```

每台机器的显示器、缩放和位置写入未受管的 `~/.config/niri/local.kdl`。首次完整 apply 会创建空文件；受管的 `config.kdl` 会包含它。

Noctalia 使用 `~/.face` 与 `~/Pictures/Wallpapers`。这些路径通过 chezmoi 的 `homeDir` 模板生成，可适配不同用户名和家目录。

检查 Niri 配置：

```sh
niri validate -c ~/.config/niri/config.kdl
```

Niri 通过 `PATH` 启动 Dolphin、Kitty 和 Fcitx5，并自动探测 Arch、Debian 与 Fedora 常见的 KDE Polkit agent 路径。

## Fcitx5 与 Kitty

应用输入法和终端配置：

```sh
chezmoi apply ~/.config/fcitx5 ~/.config/kitty/kitty.conf
```

Fcitx5 配置包含小鹤双拼、输入法顺序、快捷键和界面设置。`cached_layouts`、个人词库与运行状态不受管理。Kitty 仅管理主配置；Noctalia/Dank 生成的 `dank-theme.conf` 和 `dank-tabs.conf` 保持本地。

## Zathura

应用配置：

```sh
chezmoi apply ~/.config/zathura
```

在 Debian 上安装 Zathura 及文档后端：

```sh
sudo apt install zathura zathura-pdf-poppler zathura-djvu zathura-ps
```

`zathurarc` 管理显示、滚动、剪贴板和快捷键。默认 PDF 文件关联另存于本机的 `~/.config/mimeapps.list`，当前尚未由 chezmoi 管理。

## tmux

完整 apply 会运行一次 TPM 安装脚本，安装 `tmux`、克隆 `~/.tmux/plugins/tpm` 并安装配置中的插件。tmux prefix 设置为 `Ctrl+Space`。

本机插件目录 `~/.tmux/plugins/` 由 TPM 管理，不应加入 chezmoi source。

## Code - OSS

应用用户设置：

```sh
chezmoi apply ~/.config/"Code - OSS"/User
```

扩展不由 chezmoi 安装。配置依赖 Vim 与 Tokyo Night 等扩展；本机扩展目录和缓存保持本地。

## Chezmoi 命令

```sh
chezmoi source-path
chezmoi cd
chezmoi status
chezmoi diff
```

将本机修改写回 source：

```sh
chezmoi re-add <target-path>
```

移除管理但保留目标文件：

```sh
chezmoi forget <target-path>
```
