.PHONY: zsh clean-zsh

# 获取当前 Makefile 所在的绝对路径
CURDIR := $(shell pwd)

zsh:
	mkdir -p ~/.config/zsh
	ln -sfn $(CURDIR)/zsh/zshenv ~/.zshenv
	ln -sfn $(CURDIR)/zsh/zshrc ~/.config/zsh/.zshrc
	ln -sfn $(CURDIR)/zsh/aliases.zsh ~/.config/zsh/aliases.zsh
	@echo "Zsh 配置已链接成功！"

clean-zsh:
	rm -f ~/.zshenv
	rm -rf ~/.config/zsh
	@echo "Zsh 配置已清理（软链接已移除）。"
