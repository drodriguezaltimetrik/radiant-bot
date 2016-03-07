module RadiantBot

  @meme_list  = YAML.load_file("#{$path}/ymls/meme_list.yml")[:memes]

  def load_meme_methods!
    @client.on :message do |data|
      case data.text
        when /^!bot meme:list$/
          result = ''
          @meme_list.keys.each { |element| result << "#{element.to_s.gsub('_', ' ').titleize}, " }
          @client.web_client.chat_postMessage :channel  => data.channel,
                                              :text     => result[0..-3],
                                              :username => $config[:api_call][:bot_username],
                                              :icon_url => $config[:api_call][:icon_url]

        when /^!bot meme:info {[\w\s|\w,\s]+}$/
          meme_name_original = data.text[/{[\w\s|\w,\s]+}/]
          meme = meme_name_original[1..-2].downcase.gsub(' ', '_').to_sym

          if @meme_list[meme]
            @client.web_client.chat_postMessage :channel  => data.channel,
                                                :text     => @meme_list[meme][1],
                                                :username => $config[:api_call][:bot_username],
                                                :icon_url => $config[:api_call][:icon_url]
          else
            @client.web_client.chat_postMessage :channel  => data.channel,
                                                :text     => "No meme found for #{data.text.gsub(/^!bot meme_info /, '')}",
                                                :username => $config[:api_call][:bot_username],
                                                :icon_url => $config[:api_call][:icon_url]
          end
        when /^!bot meme:create/
          attributes = data.text.scan(/{[^{}]*}/)

          if attributes.size < 2
            @client.web_client.chat_postMessage :channel  => data.channel,
                                                :text     => 'You need at least two attributes to create a meme',
                                                :username => $config[:api_call][:bot_username],
                                                :icon_url => $config[:api_call][:icon_url]
            next
          end

          image = attributes[0][1..-2].downcase.gsub(' ', '_').to_sym

          unless @meme_list[image]
            @client.web_client.chat_postMessage :channel  => data.channel,
                                                :text     => 'Can not create this meme. Use !bot meme_list to check for the list of memes',
                                                :username => $config[:api_call][:bot_username],
                                                :icon_url => $config[:api_call][:icon_url]
            next
          end

          first_caption   = attributes[1] ? attributes[1][1..-2] : nil
          second_caption  = attributes[2] ? attributes[2][1..-2] : nil

          @client.web_client.chat_postMessage :channel  => data.channel,
                                              :text     => get_image_for(@meme_list[image][0], first_caption, second_caption),
                                              :username => $config[:api_call][:bot_username],
                                              :icon_url => $config[:api_call][:icon_url]

      end
    end
  end

  private
  def get_image_for(template, first_caption = '', second_caption = '')
    post_response = HTTParty.post($config[:api_call][:meme_post],
                                  {:body => {
                                      :username => $config[:api_call][:username],
                                      :password => $config[:api_call][:password],
                                      :template_id => template,
                                      :text0 => first_caption,
                                      :text1 => second_caption
                                  }})
    post_response['data']['url']
  end
end