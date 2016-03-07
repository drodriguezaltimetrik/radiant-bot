module RadiantBot

  def load_ruby_training_methods!
    @client.on :message do |data|
      case data.text
        when /^!bot test$/
          @client.web_client.chat_postMessage :channel  => data.channel, :text => 'TEST!'
      end
    end
  end

end