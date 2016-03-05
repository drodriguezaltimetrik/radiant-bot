require 'rake/task'
require_relative 'lib/radiant_bot'
require 'colorize'

namespace :radiant_bot do
  task :start do

    trap('INT') {
      warn "\nBot Closing".red
      exit
    }

    RadiantBot.load_meme_methods!

    warn 'Bot Starting'.green
    RadiantBot.start!
  end
end