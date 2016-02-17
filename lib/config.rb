require 'yaml'
$path = File.expand_path(File.dirname(__FILE__))
SlackRubyBot.configure do |config|
  config.token = YAML::load_file("#{$path}/config.yml")[:bot_token]
end