__END__
puts "THIS IS IT"
require 'rubygems' if RUBY_VERSION < '1.9'
require 'socket'

begin
  require 'amazing_print'
rescue LoadError
  puts 'AmazingPrint not found'
end unless ENV['NO_AMAZING_PRINT'] || defined?(AmazingPrint)

begin
  require 'term/ansicolor'
rescue LoadError
  puts 'Term::ANSIColor not found'
end unless ENV['NO_COLOR'] || defined?(Term::ANSIColor)

ENV['PAGER'] = nil

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
      Pry.new.pager.page "=> #{printed}"
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
    'green'
  end
)

if defined?(AwesomePrint)
  Pry.config.print = proc { |output, value|
    printed = value.ai

    if printed.count("\n") >= 30
      Pry.new.pager.page "=> #{printed}"
    else
      output.puts(printed)
    end
  }
end

Pry.config.prompt = Pry.config.prompt = Pry::Prompt.new(
  'prompt',
  'prompt 2',
  [
    proc { |target_self, nest_level, pry|
      "#{current_app}@#{hostname}(#{Pry.view_clip(target_self)})[#{pry.input_ring.size}]#{":#{nest_level}" unless nest_level.zero?} >> "
    },

    proc { |target_self, nest_level, pry|
      "#{current_app}@#{hostname}(#{Pry.view_clip(target_self)})[#{pry.input_ring.size}]#{":#{nest_level}" unless nest_level.zero?}  | "
    }
  ]
)

def table(objects)
  puts Hirb::Helpers::AutoTable.render(objects)
end

# vim: set ft=ruby:
