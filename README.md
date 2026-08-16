# Dotfiles

使用 [chezmoi](https://www.chezmoi.io/) 管理的个人配置，包含 Zsh、Neovim、OpenCode、tmux、Sway、Niri、Noctalia、Fcitx5、Kitty、Zathura 和 Code - OSS。

## 目录

- [部署](#部署)
- [Zsh Bootstrap](#zsh-bootstrap)
- [Zsh](#zsh)
- [Neovim](#neovim)
- [OpenCode](#opencode)
- [Sway 桌面](#sway-桌面)
- [Niri 与 Noctalia](#niri-与-noctalia)
- [Fcitx5 与 Kitty](#fcitx5-与-kitty)
- [Zathura](#zathura)
- [tmux](#tmux)
- [Code - OSS](#code---oss)
- [Chezmoi 命令](#chezmoi-命令)

## 部署

需要 `chezmoi`、网络和可用 shell。Zsh bootstrap 可使用系统包管理器、已安装的 Homebrew 或 Nix；系统包安装需要 root 或 passwordless `sudo`。

```sh
chezmoi init --apply --prompt <repository-url>
```

首次初始化会选择 desktop profile，默认是 `sway`：

```text
sway  通用配置 + Sway 主环境 + XFCE 回退，不部署 Niri/Noctalia
niri  通用配置 + Niri/Noctalia + XFCE 回退，不部署 Sway 桌面组件
all   同时部署 Sway、Niri/Noctalia 和 XFCE
core  仅 shell、编辑器、终端、输入法和通用工具
```

选择保存在机器本地的 `~/.config/chezmoi/chezmoi.toml`，不进入 source。修改 `desktopProfile` 后再次 `chezmoi apply` 即可切换受管集合；被排除的已有文件不会自动删除。

已初始化的机器更新配置：

```sh
chezmoi update
```

首次完整 `chezmoi apply` 不会自动运行包管理器、下载工具或安装 tmux 插件。只有 `niri`/`all` profile 会创建机器专属的空 Niri `local.kdl`。Zsh、tmux 和 Sway 的依赖均通过下方显式 bootstrap 命令安装。

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

- `core`：安装或确认 `git`、`zsh`，并安装 Oh My Zsh、Powerlevel10k 和 Zsh 插件。
- `tools`：仅安装可选的常用命令行工具。
- `all`：依次运行 core 与 tools。
- `--update`：更新已克隆的 Zsh 依赖；默认只克隆缺失项。

安装顺序为：有权限的系统包管理器、已有 Homebrew、Nix。缺少权限或工具时会告警并汇总需要手动安装的命令，但不会中断其余步骤。

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

### Zsh 功能备忘

- `alias -s`：后缀别名，根据文件扩展名选择打开命令。例如 `alias -s md='$EDITOR'` 后，直接输入 `README.md` 会用编辑器打开它。
- `alias -g`：全局别名，可在命令行任意位置展开，适合管道片段。例如 `alias -g G='| grep'` 后可使用 `ps aux G ssh`。
- `hash -d`：定义命名目录。例如 `hash -d proj=~/src/project` 后，可使用 `cd ~proj` 或 `ls ~proj`。
- `zmv`：Zsh 的批量重命名函数。先执行 `autoload -Uz zmv`；`zmv -n -W '*.txt' '*.md'` 预览，确认后去掉 `-n` 执行。
- `zle`：Zsh Line Editor，可查看和注册命令行编辑组件。使用 `zle -la` 查看 widgets，`zle -N name function` 将函数注册为 widget，再通过 `bindkey` 绑定。
- `magic-space`：空格对应的 ZLE widget，会先展开 `!!`、`!$` 等历史引用，再插入空格，便于执行前检查实际命令。
- `Ctrl-_`：撤销当前命令缓冲区中的上一次编辑；部分终端会将它显示或发送为 `Ctrl-/`。
- `bindkey -s`：把按键绑定为一段输入宏。例如 `bindkey -s '^Xl' 'ls -la^M'`，按 `Ctrl-X l` 后输入并执行 `ls -la`。用 `bindkey -M viins -s ...` 可限定在 vi insert 模式。

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

## Sway 桌面

Sway 是 Debian 主环境，完全使用发行版软件包，不依赖 XFCE panel 或 Noctalia。组件包括 Waybar、Mako、Wofi、Swaylock、Swayidle、Cliphist、Grim、Slurp、PipeWire、NetworkManager、BlueZ、UPower 和 Fcitx5。

在 Debian netinst 或新机器上，`chezmoi init --apply` 部署配置和脚本后再运行：

```sh
chezmoi apply
~/.local/bin/bootstrap-sway-debian
```

bootstrap 仅支持 Debian 13，应在本机图形会话或控制台执行；检测到 SSH 会话时会跳过 UFW 策略修改，避免切断远程连接。它会安装 LightDM、Slick Greeter、Restic、thermald 和完整桌面依赖，并使用与 Swaylock 相同的 Graphite 壁纸、Adwaita Dark 主题和 Noto Sans 字体。已有其他显示管理器的机器执行前，应先决定是否切换默认显示管理器；默认会话设为 `Sway`，登录界面仍可切换其他桌面。

常用快捷键：

```text
Alt+Ctrl+T       Kitty
Alt+D            Dolphin
Alt+Shift+Q      关闭当前窗口
Alt+R            进入窗口大小调整模式
Alt+Shift+R      重新加载 Sway
Super+F          Wofi 应用启动器
Super+V          Wofi 紧凑文字剪贴板并自动粘贴
Super+Shift+V    Wofi 320px 图片剪贴板并自动粘贴
Super+Shift+O    启用/禁用机器配置中的外接显示器
Super+L          Swaylock 锁屏
Super+Shift+L    锁定当前会话并进入用户选择
Super+,          图形化设置中心
Super+X          会话与电源菜单
Print            当前输出截图
Shift+Print      区域截图
Alt+Shift+A/D    将当前工作区移到左/右显示器
Alt+A/C          聚焦父容器/返回子窗口
Alt+W            将当前容器设为 tabbed
Alt+E            在水平/垂直 split 之间切换
```

工作区使用 `1.Web`、`2.Dev`、`3.Doc`、`4.Note`、`5.Chat`、`8.Sys`、`9.AI`。Edge、开发工具、笔记、聊天软件、Kitty 和 AI 客户端会在创建窗口时自动分配到对应工作区；应用自动分配不强制切换当前视角，`Alt+Shift+数字` 移动窗口后会跟随到目标工作区。工作区使用 Sway 原生 default layout，新窗口默认在当前层级均分空间；`Alt+B/V` 指定下一窗口左右/上下分屏，`Alt+W` 将当前层级改为 tabbed，`Alt+E` 切换当前 split 的方向。容器层级使用原生 `Alt+A/C` 上下导航，不再使用 tabbed 辅助脚本。

Waybar 的网络和蓝牙模块分别按需打开 `nm-connection-editor` 与 `blueman-manager`，不常驻 applet。Mako 和 Waybar 由 Sway 直接启动，其 Debian user services 被 mask，避免重复实例；XFCE 仍使用自己的 Notifyd。Mako 只在 Sway 会话中运行，与 Niri 会话中的 Noctalia 通知服务互斥。显示器和机器特有设置可另建 `~/.config/sway/local`，并在主配置末尾按需 include。

图形化设置中心由 `nwg-bar` 提供，只在打开时运行。它按需启动 NetworkManager 连接编辑器、Blueman、Pavucontrol、nwg-displays、Azote、nwg-look、Fcitx5 配置、Qt5/Qt6 外观、Waybar 设置和电源菜单。Waybar 的 `SETTINGS` 按钮以及网络、蓝牙模块的右键都可打开设置中心。

设置应用默认以 `1000x700` 居中浮动窗口打开。Swaylock 使用桌面同款壁纸，常驻显示大号解锁指示器，并使用独立颜色区分输入、Caps Lock、验证和密码错误状态，同时显示当前键盘布局。Swaylock 不显示密码长度；这是避免旁观者推断密码长度的上游安全设计。`Super+Shift+L` 和会话菜单中的 `Switch user` 会在后台用 Swaylock 保护当前会话，LightDM 成功认证并清除 logind 锁定状态后自动结束 Swaylock，因此正常返回只需在 Slick Greeter 认证一次。

`nwg-displays` 生成的 `~/.config/sway/outputs` 和 Azote 生成的 `~/.azotebg` 是机器专属文件，不由 chezmoi 管理。主 Sway 配置会自动 include/执行这些文件；显示器切换脚本从 Sway IPC 或 `outputs` 自动选择第一个非内置输出，不在共享配置中写死 connector 名称。

### 备份与电源

本机 1TB 数据盘通过 UUID 挂载到 `/data`；`/etc/fstab` 是机器专属系统配置，不由 chezmoi 管理。Restic 仓库位于 `/data/Backups/restic`，密码文件是未受管的 `~/.config/restic/password`，必须另存一份离线副本。Timer 每天 20:00 检查，距离最新快照满 3 天时才备份 Home；保留 8 周、12 月和 3 年快照：

备份脚本和 unit 受管，但 timer 启用 symlink、密码、仓库初始化和挂载状态不受管。其他机器可在未受管的 `~/.config/restic/environment` 中覆盖 `RESTIC_REPOSITORY`、`RESTIC_PASSWORD_FILE` 和 `BACKUP_MOUNTPOINT`，确认仓库可用后再显式启用 timer。

```sh
systemctl --user status desktop-backup.timer
systemctl --user enable --now desktop-backup.timer
~/.local/bin/desktop-backup --force
RESTIC_REPOSITORY=/data/Backups/restic RESTIC_PASSWORD_FILE=~/.config/restic/password restic snapshots
```

恢复前可先输出到临时目录检查：

```sh
RESTIC_REPOSITORY=/data/Backups/restic RESTIC_PASSWORD_FILE=~/.config/restic/password \
  restic restore latest --target /tmp/restic-restore --include "$HOME/path/to/file"
```

Swayidle 在 5 分钟锁屏、10 分钟关闭显示器；电池供电时 30 分钟挂起，接电时 60 分钟挂起。Waybar idle inhibitor 可暂停这些超时。UPower 在 2% 电量执行 HybridSleep，thermald 管理 Intel CPU 温控。systemd-timesyncd 提供网络时间同步，smartd 使用 standby-aware 规则监控系统 SSD 和 1TB 机械盘。

UFW 使用 IPv4/IPv6 默认拒绝入站、允许出站的基础策略，未预先开放服务端口；新增局域网服务时应按需添加规则。系统盘与数据盘当前均未使用 LUKS，磁盘加密留待下次重装时处理。本地 Restic 仓库不能防整机丢失或数据盘故障，外置或远端第二副本尚未配置；`/data/Project` 和 Obsidian 的反向 SSD 备份也尚未配置。安全更新保持手动安装，未启用 unattended-upgrades 或 fwupd。

检查配置：

```sh
sway -C -c ~/.config/sway/config
jq -e . ~/.config/waybar/config.jsonc
wofi --conf ~/.config/wofi/launcher.conf --style ~/.config/wofi/style.css --show drun
```

## Niri 与 Noctalia

按需应用：

```sh
chezmoi apply ~/.config/niri ~/.config/noctalia
```

Niri 依赖 `niri`、`noctalia`、`kitty`、`dolphin`、`fcitx5`、`xwayland-satellite`、`playerctl`、`brightnessctl`、`wireplumber` 和 `niri-switch`。显示器名称可通过以下命令查看：

`niri`/`all` profile 管理 Niri/Noctalia 配置、`niri-session`、Wayland session desktop entry 和 systemd unit，但不管理 Niri/Noctalia 二进制或第三方软件仓库；软件依赖必须先单独安装。

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

`chezmoi apply` 只部署 tmux 配置，不访问网络。安装 `git` 和 `tmux` 后显式运行：

```sh
~/.local/bin/bootstrap-tmux
~/.local/bin/bootstrap-tmux --update
```

脚本会克隆或更新 `~/.tmux/plugins/tpm`，并安装配置中的插件。tmux prefix 设置为 `Ctrl+Space`。

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
