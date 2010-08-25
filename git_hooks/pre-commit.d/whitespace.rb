#!/usr/bin/env ruby

exit(0) if `git config hooks.commit.checkws`.strip != 'true'

color_ui = `git config color.ui`.strip == 'true'

# A default msg method in case the term-ansicolor gem isn't installed...
def msg(m, fg = nil, bg = nil)
	m
end

if color_ui
	begin
		require 'rubygems'
		require 'term/ansicolor'

		def msg(m, fg = nil, bg = nil)
			m = Term::ANSIColor.send(bg) { m } if bg
			m = Term::ANSIColor.send(fg) { m } if fg
		end
	rescue LoadError
		# couldn't load up rubygems or term-ansicolor
	end
end

`git rev-parse --verify HEAD`
against = if $? == 0
	'HEAD'
else
	'4b825dc642cb6eb9a060e54bf8d69288fbee4904'
end

files = `git diff-index #{color_ui ? '--color' : ''} --check --cached #{against}`
unless $? == 0
	puts "#{msg('/!\\', 'white', 'on_red')} #{msg('WHOA THERE', 'red')}, #{msg('/!\\', 'white', 'on_red')}\n\n"
	puts "#{msg('Whitespace', 'black', 'on_white')} problems in commit! Take a gander at this:\n\n"
	puts "#{files}\n\n"
	exit(1)
end

exit(0)
