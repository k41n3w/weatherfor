require "weatherfor/version"
require 'net/http'
require 'json'

module Weatherfor
  class Error < StandardError; end
  
  class ApiConsultant
    def initialize(city, api_id)
      uri = URI("https://api.openweathermap.org/data/2.5/forecast?q=#{city}&appid=#{api_id}&lang=pt_br&units=metric")
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

    def weather_in_days
      arr = []
      @json['list'].group_by{ |item| Time.at(item['dt']).strftime("%m-%d-%Y") }.each do |date,data|
        avg_temp = data.sum { |info| info['main']['temp'] }
        avg_temp = avg_temp / 8
        arr << { avg_temp: avg_temp, date: date }
      end
      
      parse_avg_text(arr)
    end

    private

    def parse_avg_text(arr)
      current_temp = @json['list'][0]['main']['temp']
      city_name = @json['city']['name']
      weather_description = @json['list'][0]['weather'][0]['description']
      current_date =  arr.first[:date].gsub('-', '/').delete_suffix('/2021') 
      text = "#{current_temp.round(0)}°C e #{weather_description} em #{city_name} em #{current_date}. Média para os próximos dias: "
    
      arr.last(4).each_with_index do |item, index|
        text += "#{item[:avg_temp].round(0)}°C em #{item[:date].gsub('-', '/').delete_suffix('/2021')}"
        if index < 3
          text += ", " 
        else
          text += "."
        end
      end
      
      text
    end
  end
end
