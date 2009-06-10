require "yaml"
require 'rubygems'
require 'twitter'
require 'net/http'
require 'pp'

class Squarespace_hack
  def initialize(user_name)
    p "initializing #{user_name}"
    @user_name = user_name
    load_twitter_config_for
    get_twitter_session
    run
  end
  
  def load_twitter_config_for
    p "loading twitter config"
    @twitter_config = YAML::load(File.open("twitter.yaml"))
    @app = @twitter_config['application']
    @config = @twitter_config[@user_name]
  end
    
  def get_twitter_session
    p "getting a twitter session"    
    
    httpauth = Twitter::HTTPAuth.new(@config['email'], @config['password'])
    @client = Twitter::Base.new(httpauth)
  end
  
  def winner?
    @client.replies.each {|tweet| return true if tweet.user.screen_name.downcase == "squarespace" }
    return false
  end
  
  def random_twitt
    text = Net::HTTP.get(::URI.parse("http://iheartquotes.com/api/v1/random?format=raw&max_lines=4&max_characters=120&show_permalink=false&show_source=false"))
    return text + " #squarespace"
  end
  
  def run
    p "go !"
    while not winner? do
      text =  random_twitt
      p 'twitting for ' + @user_name + ' : ' + text
      @client.update(text)
      sleep 90
    end
    p "WE WON !!!!!!!"
  end
end

Squarespace_hack.new(ARGV.first)