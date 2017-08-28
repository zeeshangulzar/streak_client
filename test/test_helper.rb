require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/byebug'

require 'streak_client'
StreakClient.api_key = ENV['STREAK_API_KEY']
