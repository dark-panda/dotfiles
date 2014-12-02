
require 'rubygems' if RUBY_VERSION < '1.9'
require 'socket'

begin
  require 'awesome_print'
rescue LoadError
  puts 'AwesomePrint not found'
end unless ENV['NO_AWESOME_PRINT'] || defined?(AwesomePrint)

begin
  require 'brice'
rescue LoadError
  puts 'Brice not found'
end unless ENV['NO_BRICE'] || defined?(Brice)

begin
  require 'term/ansicolor'
rescue LoadError
  puts 'Term::ANSIColor not found'
end unless ENV['NO_COLOR'] || defined?(Term::ANSIColor)

ENV['PAGER'] = nil

if defined?(Brice)
  Brice.init { |config|
    config.exclude(:added_methods)
  }
end

if RUBY_VERSION >= '1.9.3' && defined?(Term) && defined?(Term::ANSIColor) #&& false
  def __pry_color_ui__(msg, *colors)
    fg, bg = colors
    msg = Term::ANSIColor.send(bg) { msg } if bg
    msg = Term::ANSIColor.send(fg) { msg } if fg
  end
else
  def __pry_color_ui__(msg, *colors)
    msg
  end
end

if defined?(AwesomePrint)
  Pry.config.print = proc { |output, value|
    printed = value.ai

    if printed.count("\n") >= 30
      Pry::Helpers::BaseHelpers.stagger_output("=> #{printed}", output)
    else
      output.puts(printed)
    end
  }
end

if defined?(Rails) || ENV['RAILS_ENV']
  rails_env = if defined?(Rails)
    Rails.env.downcase
  else
    ENV['RAILS_ENV']
  end

  current_app = [
    Dir.pwd.split('/').last,

    __pry_color_ui__(
      rails_env[0, 3],
      case rails_env
        when 'production'
          'red'
        else
          'yellow'
      end
    )
  ].join(':')
else
  current_app = RUBY_VERSION
end

hostname = __pry_color_ui__(
  Socket.gethostname.split('.').first,

  if ENV['SSH_CLIENT']
    'yellow'
  else
    case Socket.gethostname
      when /(zoocasa.com|i.internal)$/
        'cyan'
      else
        'green'
    end
  end
)

Pry.config.prompt = [
  proc { |target_self, nest_level, pry|
    "#{current_app}@#{hostname}(#{Pry.view_clip(target_self)})[#{pry.input_array.size}]#{":#{nest_level}" unless nest_level.zero?} >> "
  },

  proc { |target_self, nest_level, pry|
    "#{current_app}@#{hostname}(#{Pry.view_clip(target_self)})[#{pry.input_array.size}]#{":#{nest_level}" unless nest_level.zero?}  | "
  }
]

# vim: set ft=ruby:
