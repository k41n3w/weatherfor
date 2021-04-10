require "weatherfor/version"
require 'net/http'
require 'json'

module Weatherfor
  class Error < StandardError; end
  
  class WhoIs
    def self.consult_api(city, api_id)
      uri = URI("https://api.openweathermap.org/data/2.5/forecast?q=#{city}&appid=#{api_id}")
      res = Net::HTTP.get_response(uri);nil

      if res.code == '200'
        @json = JSON.parse res.body
      else
        return { 'error' => res.message }
      end
    end

    def self.list(city, api_id)
      self.consult_api(city, api_id)
      @json['list']
    end

    def self.city_info(city, api_id)
      self.consult_api(city, api_id)
      @json['city']
    end
  end
end
