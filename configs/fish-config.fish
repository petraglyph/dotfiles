# Fish Configuration
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
set -U fish_greeting ""


# Imports and PATH
if test -f $HOME/.profile
	source $HOME/.profile
end
if test -f $HOME/.aliasrc
	source $HOME/.aliasrc
end
for bin in $HOME/.local/share/flatpak/exports/bin $HOME/.cargo/bin /usr/local/bin $HOME/.local/bin
	if ! test -d $bin
		continue
	else if string match -q $bin $PATH
		continue
	end
	set -gpx PATH $bin
end
if test -z "$PYTHONPATH" -a ! -z "$(command -v python3)"
	set -l python_str $(python3 -V | sed -E -e 's/\.[0-9]+$//' -e 's/^.* /python/')
	set -gx PYTHONPATH "$HOME/.local/lib/$python_str/site-packages"
end


# Shell prompt and style
function fish_user_key_bindings
	fish_vi_key_bindings --no-erase insert
end
function fish_mode_prompt
end
function fish_prompt
	set -f color_primary green
	set -f user_char "\$"
	if fish_is_root_user
		set -f user_char "#"
	end

	# starter
	set_color --bold $color_primary
	echo -n "["
	set_color normal

	# ssh indicator
	if test -n "$SSH_CONNECTION"
		set_color yellow
		echo -n "ssh:"
	end
	# toolbox/distrobox indicator
	if test -n "$(uname -s 2> /dev/null | grep Linux)"
		if test -n "$(cat /proc/mounts | grep -w / | cut -d" " -f 1 | grep overlay)"
			set_color magenta
			echo -n "box:"
		end
	end

	# user@hostname
	if fish_is_root_user
		set_color --bold red
		echo -n "$(prompt_hostname)"
	else
		set_color --bold $color_primary
		echo -n "$USER@$(prompt_hostname)"
	end

	# directory
	set_color --bold white
	echo -n " $(prompt_pwd)"

	# git
	if test $(git rev-parse --is-inside-work-tree 2> /dev/null)
		set -l git_branch "$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
		set_color --bold blue
		echo -n " $git_branch"
		set_color normal
		if test $(git status --short 2> /dev/null | wc -l) -gt 0
			set_color red
			echo -n "+$(git status --short | wc -l)"
		end
	end

	# ender
	set_color --bold $color_primary
	echo -n "]"
	switch $fish_bind_mode
		case insert
			echo -n "$user_char "
		case default
			set_color --bold magenta
			echo -n "% "
		case replace_one
			set_color --bold yellow
			echo -n "^ "
		case visual
			set_color --bold cyan
			echo -n "> "
		case *
			set_color --bold red
			echo -n "? "
	end
	set_color normal
end
function fish_right_prompt
	# Day 00:00:00
	date '+%a %T'
end

set -gx fish_color_param white
set -gx fish_color_command cyan
set -gx fish_color_option yellow
set -gx fish_color_redirection blue
