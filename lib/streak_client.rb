require 'rest-client'
require 'multi_json'

require 'resources/box'
require 'resources/field'
require 'resources/newsfeed'
require 'resources/pipeline'
require 'resources/snippet'
require 'resources/stage'
require 'resources/task'
require 'resources/thread'
require 'resources/user'

module StreakClient

  @@api_protocol = "https"
  @@api_key = nil
  @@api_base_url = "www.streak.com/api"

  def self.api_key=(key)
    @@api_key = key
  end

  def self.api_key
    @@api_key
  end

  def self.api_base_url
    @@api_base_url
  end

  def self.api_protocol
    @@api_protocol
  end

  def self.api_url(api_version = 'v1')
    "#{api_protocol}://#{api_key}@#{api_base_url}/#{api_version}"
  end

end
