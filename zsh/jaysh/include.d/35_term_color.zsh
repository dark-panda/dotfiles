# The follow snippets will automatically change your iTerm2 tab color when you enter a configured directory.
#
# This hooks `_iterm_tab_color` into zsh's precmd so it runs automatically
# before every prompt (i.e. whenever the directory may have changed) -
# no PS1/PROMPT wiring required.
#
# You can configure a color for your current directory by running
#    `_set_cwd_tab_color r g b` (where `r`, `g` and `b` are numbers between 0 and 255.)
#
# (You should also consider adding `.iterm_tab_color` to your `~/.gitignore_global` file.)
#
# See also: https://iterm2.com/documentation-escape-codes.html

_tab_color_rgb() {
	local R=${1?'Provide red brightness (0-255) as first arg.'}
	local G=${2?'Provide green brightness (0-255) as second arg.'}
	local B=${3?'Provide blue brightness (0-255) as third arg.'}

	echo -ne "\033]6;1;bg;red;brightness;${R}\a"
	echo -ne "\033]6;1;bg;green;brightness;${G}\a"
	echo -ne "\033]6;1;bg;blue;brightness;${B}\a"
}

_tab_color_reset() {
	echo -ne "\033]6;1;bg;*;default\a"
}

_read_cwd_tab_color() {
	if [ -r '.iterm_tab_color' ]; then
		echo $(< .iterm_tab_color)
	fi
}

_set_cwd_tab_color() {
	local R=${1?'Provide red brightness (0-255) as first arg.'}
	local G=${2?'Provide green brightness (0-255) as second arg.'}
	local B=${3?'Provide blue brightness (0-255) as third arg.'}

	echo "$R $G $B" > '.iterm_tab_color'
}

_iterm_tab_color() {
	local OVERRIDE="$(_read_cwd_tab_color)"
	if [ -n "$OVERRIDE" ]; then
		_tab_color_rgb ${=OVERRIDE}
	else
		local DIR="$(basename "$PWD")"
		case "$DIR" in
			# You can also specify dir colors here to avoid loose files everywhere.
			# Example:
			# your_dir_basename_here) _tab_color_rgb 255 0 0 ;;
			*) _tab_color_reset ;;
		esac
	fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _iterm_tab_color
