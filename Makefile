SHELL_FILES ?= .ackrc .bash_profile .bashrc .dircolors .gitconfig .inputrc .jshintrc .lftprc .ls++.conf .linopenrc .apvlvrc \
	.bash/aliases.sh .bash/colors.sh .bash/exports.sh .bash/functions.sh .bash/prompt.sh .bash/shell.sh \
	.bash_completion.d/misc $(wildcard .local/bin/*)

CRON_FILES ?= $(wildcard .cron/*)
XORG_FILES ?= .Xresources .xbindkeysrc .xinitrc $(wildcard .urxvt/*)
XMONAD_FILES ?= .xmonad/xmonad.hs .config/dunst/dunstrc .xmonad/conky .xmonad/icons .xmonad/scripts
DRUPAL_FILES ?= .bash/drush.sh .ctags
MUTT_FILES ?= .mutt/colors.muttrc .mutt/muttrc .mutt/sig .mutt/mailcap .msmtprc .offlineimaprc \
							.local/bin/mutt-notmuch .notmuch-config
TMUX_FILES ?= .tmux.conf .bash_completion.d/tmux $(wildcard .tmux/sessions/*)
TODO_FILES ?= .todo.cfg
GTK_FILES ?= .gtkrc-2.0
WEECHAT_FILES ?= $(wildcard .weechat/*)

TARGETS_CLEAN ?= XORG XMONAD DRUPAL MUTT TMUX TODO IRSSI SHELL

MUTT_DIRS ?= .mutt/cache/bodies .mutt/cache/headers .mutt/temp .goobookrc
SHELL_DIRS ?= .backup
TMUX_DIRS ?= .tmux/sessions .tmux/sockets
TODO_DIRS ?= .todo

LIB_DIR ?= ~/.local/lib

BACKUP ?= $(HOME)/.dotfiles-backup/$(shell date +"%Y%m%d_%H%M")

DEST ?= $(HOME)

all:

update: fetch-github

fetch-github:
	@git pull origin master
	@git submodule foreach git pull origin master

install: clean xorg drupal mutt tmux todo weechat shell gtk
	@if ! perl -MTerm::ExtendedColor -e 1 2>/dev/null; then \
		cpan Term::ExtendedColor; \
	fi
	@echo "Remember to source ~/.bash_profile"

# Main targets ----------------------------------------------------------------

xorg: $(addprefix $(DEST)/,$(XORG_FILES))

cron: $(addprefix $(DEST)/,$(CRON_FILES))

gtk: $(addprefix $(DEST)/,$(GTK_FILES))

xmonad: $(addprefix $(DEST)/, $(XMONAD_FILES))

drupal: $(addprefix $(DEST)/,$(DRUPAL_FILES))

mutt: $(addprefix $(DEST)/,$(MUTT_FILES))
	@mkdir -p $(addprefix $(DEST)/,$(MUTT_DIRS))

tmux: $(addprefix $(DEST)/,$(TMUX_FILES))
	@mkdir -p $(addprefix $(DEST)/,$(TMUX_DIRS))

todo: $(addprefix $(DEST)/,$(TODO_FILES))
	@mkdir -p $(addprefix $(DEST)/$(TODO_DIRS))

weechat: $(addprefix $(DEST)/,$(WEECHAT_FILES))

shell: $(addprefix $(DEST)/,$(SHELL_FILES))
	@mkdir -p $(addprefix $(DEST)/,$(SHELL_DIRS))
	@git submodule init
	@git submodule update

yslow:
	@git clone git://github.com/marcelduran/yslow.git /tmp/yslow \
		&& pushd /tmp/yslow \
		&& make -s phantomjs \
		&& mv build/phantomjs/yslow.js $(LIB_DIR)/ \
		&& popd \
		&& rm -rf /tmp/yslow

node: yslow

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

.PHONY: xorg xmonad drupal mutt tmux todo weechat shell clean-target clean install gtk
