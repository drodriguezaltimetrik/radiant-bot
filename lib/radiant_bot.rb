require_relative 'config'
require_relative 'modules/memes'
require_relative 'modules/ruby_training'

module RadiantBot
  extend self
  extend Forwardable

  def_delegators :@client, :start!, :stop!

  @client     = Slack::RealTime::Client.new
end
