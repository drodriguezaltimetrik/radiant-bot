require 'rake/task'
require_relative 'lib/radiant_bot'

namespace :radiant_bot do
  task :start do

    RadiantBot.load_meme_methods!

    warn 'Bot Starting'
    RadiantBot.start!
  end
end