require_relative 'config'
require_relative 'modules/memes'

module RadiantBot
  extend self
  extend Forwardable

  def_delegator :@client, :start!

  @client     = Slack::RealTime::Client.new
  @meme_list  = YAML.load_file("#{$path}/ymls/meme_list.yml")[:memes]

end
