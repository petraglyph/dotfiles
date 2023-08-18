# Fish Configuration
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
set -U fish_greeting ""


# Add command aliases
if test -f $HOME/.aliasrc
	source $HOME/.aliasrc
end


# Shell prompt and style
function fish_user_key_bindings
	fish_vi_key_bindings --no-erase insert
end
function fish_mode_prompt
end
function fish_prompt
	set -l color_primary green

	# starter
	set_color --bold $color_primary
	printf "["
	set_color normal

	# ssh indicator
	if test -n "$SSH_CONNECTION"
		set_color yellow
		printf "ssh:"
	end
	# toolbox/distrobox indicator
	if test -f /run/.containerenv
		set_color magenta
		printf "box:"
	end

	# user@hostname
	set -l name (prompt_hostname)
	if test -f /run/.toolboxenv
		set name (grep '^name=' /run/.containerenv | cut -d'"' -f 2)
		if string match -rq '^[a-z]+-toolbox-[.a-z0-9]+$' $name
			set name (echo $name | sed 's/-toolbox-/-/')
		end
	end
	if test (id -u) -eq 0
		set_color --bold red
		printf "%s" $name
	else
		set_color --bold $color_primary
		printf "%s@%s" $USER $name
	end

	# directory
	set_color normal
	printf " %s" (prompt_pwd)

	# git
	if test (command -v git)
		if test (git rev-parse --is-inside-work-tree 2> /dev/null)
			set -l git_branch (git rev-parse --abbrev-ref HEAD 2> /dev/null)
			set_color --bold blue
			printf " %s" $git_branch
			set_color normal
			if test (git status --short 2> /dev/null | wc -l) -gt 0
				set_color red
				set -l mod_count (git status --short | wc -l)
				printf "+%d" $mod_count
			end
		end
	end

	# ender
	set_color --bold $color_primary
	printf "]"
	switch $fish_bind_mode
		case insert
			if test (id -u) -eq 0
				printf "# "
			else
				printf "\$ "
			end
		case default
			set_color --bold magenta
			printf "%% "
		case replace_one
			set_color --bold yellow
			printf "^ "
		case visual
			set_color --bold cyan
			printf "> "
		case *
			set_color --bold red
			printf "? "
	end
	set_color normal
end

# Command style
set -gx fish_color_param white
set -gx fish_color_command cyan
set -gx fish_color_option yellow
set -gx fish_color_redirection blue
