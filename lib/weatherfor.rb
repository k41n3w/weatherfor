require "weatherfor/version"
require 'net/http'
require 'json'

module Weatherfor
  class Error < StandardError; end
  
  class ApiConsultant
    def initialize(city, api_id)
      @city = city
      @api_id = api_id

      uri = URI("https://api.openweathermap.org/data/2.5/forecast?q=#{@city}&appid=#{@api_id}")
      res = Net::HTTP.get_response(uri);nil

      if res.code == '200'
        @json = JSON.parse res.body
      else
        return { 'error' => res.message }
      end
    end

    def city
      @json['city']
    end

    def list
      @json['list']
    end
  end
end
