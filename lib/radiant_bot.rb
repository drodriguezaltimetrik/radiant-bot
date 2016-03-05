require_relative 'config'
require_relative 'modules/memes'

module RadiantBot
  extend self
  extend Forwardable

  def_delegators :@client, :start!, :stop!

  @client     = Slack::RealTime::Client.new
end
