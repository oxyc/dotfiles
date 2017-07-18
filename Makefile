SHELL_FILES ?= .agignore .bash_profile .bashrc .dircolors .gitconfig .inputrc .lftprc \
	.bash/aliases.sh .bash/colors.sh .bash/exports.sh .bash/functions.sh .bash/prompt.sh .bash/shell.sh \
	.bash/ssh-agent.sh .bash_completion.d/misc $(wildcard .local/bin/*)

CRON_FILES ?= $(wildcard .cron/*)
XORG_FILES ?= .Xresources .xbindkeysrc .xinitrc $(wildcard .urxvt/*)
XMONAD_FILES ?= .xmonad/xmonad.hs .config/dunst/dunstrc .xmonad/conky .xmonad/icons .xmonad/scripts
TMUX_FILES ?= .tmux.conf .bash_completion.d/tmux $(wildcard .tmux/sessions/*)
GTK_FILES ?= .gtkrc-2.0
WEECHAT_FILES ?= $(wildcard .weechat/*)

LINUX_FILES ?= .linopenrc .apvlvrc .bash/linux.sh
OSX_FILES ?= .khdrc

TARGETS_CLEAN ?= XORG XMONAD TMUX SHELL OSX

TMUX_DIRS ?= .tmux/sessions .tmux/sockets

LIB_DIR ?= ~/.local/lib

BACKUP ?= $(HOME)/.dotfiles-backup/$(shell date +"%Y%m%d_%H%M")

DEST ?= $(HOME)

all:

update: fetch-github

fetch-github:
	@git pull origin master
	@git submodule foreach git pull origin master

install:
	@echo "Use either install-linux install-mac depending on your system"

install-linux: clean linux xorg mutt tmux weechat shell gtk init

install-mac: clean tmux shell osx init

init:
	@echo "Remember to source ~/.bash_profile"

# Main targets ----------------------------------------------------------------

linux: $(addprefix $(DEST)/,$(LINUX_FILES))

osx: $(addprefix $(DEST)/,$(OSX_FILES))

xorg: $(addprefix $(DEST)/,$(XORG_FILES))

cron: $(addprefix $(DEST)/,$(CRON_FILES))

gtk: $(addprefix $(DEST)/,$(GTK_FILES))

xmonad: $(addprefix $(DEST)/,$(XMONAD_FILES))

tmux: $(addprefix $(DEST)/,$(TMUX_FILES))
	@mkdir -p $(addprefix $(DEST)/,$(TMUX_DIRS))

weechat: $(addprefix $(DEST)/,$(WEECHAT_FILES))

shell: $(addprefix $(DEST)/,$(SHELL_FILES))
	@git submodule init
	@git submodule update

# Helpers ---------------------------------------------------------------------

# Symlink a dotfile from the repo to $HOME
# This will only run if the file doesnt already exist.
$(HOME)/%:%
	@echo "Symlinking $^ to $@"
	@mkdir -p $(dir $@)
	@ln -sf $(PWD)/$^ $@

# Backup and delete a file
$(BACKUP)/%:%
	@if [[ -f $(DEST)/$^ ]]; then \
		echo "Backing up $(DEST)/$^ to $@"; \
		mkdir -p $(dir $@); \
		cp $(DEST)/$^ $@; \
		rm $(DEST)/$^ $@; \
	fi

# Clean up a specific target set of files
# Usage: make CLEAN=MUTT target-clean
clean-target: $(addprefix $(BACKUP)/,$($(CLEAN)_FILES))

# Backup and delete all existing dotfiles.
clean:
	@$(foreach target,$(TARGETS_CLEAN), make -s CLEAN=$(target) clean-target;)

.PHONY: xorg xmonad mutt tmux weechat shell clean-target clean install gtk
