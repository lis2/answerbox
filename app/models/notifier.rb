class Notifier
  include Singleton

  def heroku_faye_app
    "http://127.0.0.1:#{ENV["FAYEPORT"]}/faye"
  end

  def faye_post_link
    heroku_faye_app
  end
  
  def faye_js_link
    "#{heroku_faye_app}.js"
  end

  def system_password
    "password"
  end

  def broadcast_message(channel,message,token=system_password)
    message = {:channel => channel, :data => message, :ext => {:auth_token => token}}
    uri = URI.parse(faye_post_link)
    succeeded = true

    puts "[Notifier] Sending on channel #{channel} data #{message}"

    begin
      Net::HTTP.post_form(uri, :message => message.to_json)
    rescue => e
      puts "Error #{e.inspect} posting message"
      succeeded = false
    end

    succeeded
  end

end
