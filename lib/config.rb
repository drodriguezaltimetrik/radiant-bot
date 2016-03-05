require 'yaml'
require 'httparty'
require 'json'
require 'slack-ruby-client'
require 'titleize'

$path   = File.expand_path(File.dirname(__FILE__))
$config = YAML::load_file("#{$path}/ymls/config.yml")

Slack.configure do |config|
  config.token = $config[:bot_token]
end

def load_list!
  meme_list = YAML.load_file("#{$path}/ymls/meme_list.yml")
  if meme_list
    return if Time.now - meme_list[:last_updated] < 86400
  end

  #load meme_list.yml
  response = HTTParty.get('https://api.imgflip.com/get_memes')
  list = JSON.parse response.body

  list['data']['memes'].each do |element|
    symbol = element['name'].downcase.gsub(' ', '_').to_sym
    next if meme_list[:memes][:symbol]
    meme_list[:memes] = meme_list[:memes].merge({symbol => [element['id'].to_i, element['url']]})
  end

  meme_list[:last_updated] = Time.now

  File.open("#{$path}/ymls/meme_list.yml",'w') do |h|
    h.write meme_list.to_yaml
  end
end

load_list!