SHELL_FILES ?= .ackrc .bash_profile .bashrc .dircolors .gitconfig .inputrc .jshintrc .lftprc .ls++.conf \
	.bash/aliases.sh .bash/exports.sh .bash/functions.sh .bash/prompt.sh .bash/shell.sh \
	.bash_completion.d/misc $(wildcard .local/bin/*)

XORG_FILES ?= .xsession .Xdefaults .xbindkeysrc
XMONAD_FILES ?= .xmonad/xmonad.hs .xmobarrc
DRUPAL_FILES ?= .bash/drush.sh .ctags
MUTT_FILES ?= .mutt/colors.muttrc .mutt/muttrc .mutt/sig .msmtprc .offlineimaprc .mailcap \
							.mutt/certificates/Equifax_Secure_CA.cert
TMUX_FILES ?= .tmux.conf .bash_completion.d/tmux
TODO_FILES ?= .todo.cfg
IRSSI_FILES ?= .irssi/dark.theme
GTK_FILES ?= .gtkrc-2.0

TARGETS_CLEAN ?= XORG XMONAD DRUPAL MUTT TMUX TODO IRSSI SHELL

MUTT_DIRS ?= .mutt/cache/bodies .mutt/cache/headers .mutt/temp
SHELL_DIRS ?= .backup
TMUX_DIRS ?= .tmux/sessions .tmux/sockets
TODO_DIRS ?= .todo

BACKUP ?= $(HOME)/.dotfiles-backup/$(shell date +"%Y%m%d_%H%M")

DEST ?= $(HOME)

all:

update: fetch-github

fetch-github:
	@git pull origin master
	@git submodule foreach git pull origin master

install: clean xorg drupal mutt tmux todo irssi shell gtk
	@if ! perl -MTerm::ExtendedColor -e 1 2>/dev/null; then \
		cpan Term::ExtendedColor; \
	fi
	@echo "Remember to source ~/.bash_profile"

# Main targets ----------------------------------------------------------------

xorg: $(addprefix $(DEST)/,$(XORG_FILES))

gtk: $(addprefix $(DEST)/,$(GTK_FILES))

xmonad: $(addprefix $(DEST)/, $(XMONAD_FILES))

drupal: $(addprefix $(DEST)/,$(DRUPAL_FILES))

mutt: $(addprefix $(DEST)/,$(MUTT_FILES))
	@mkdir -p $(addprefix $(DEST)/,$(MUTT_DIRS))

tmux: $(addprefix $(DEST)/,$(TMUX_FILES))
	@mkdir -p $(addprefix $(DEST)/,$(TMUX_DIRS))

todo: $(addprefix $(DEST)/,$(TODO_FILES))
	@mkdir -p $(addprefix $(DEST)/$(TODO_DIRS))

irssi: $(addprefix $(DEST)/,$(IRSSI_FILES))

shell: $(addprefix $(DEST)/,$(SHELL_FILES))
	@mkdir -p $(addprefix $(DEST)/,$(SHELL_DIRS))

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

.PHONY: xorg xmonad drupal mutt tmux todo irssi shell clean-target clean install gtk
