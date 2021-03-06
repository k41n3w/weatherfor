# frozen_string_literal: true

require 'weatherfor/version'
require 'net/http'
require 'json'

module Weatherfor
  class Error < StandardError; end

  # Make the API request and parse data
  class ApiConsultant
    attr_reader :obj

    def initialize(city, api_id)
      uri = url(city, api_id)
      res = Net::HTTP.get_response(uri)

      @obj = case res.code
             when '200'
               JSON.parse(res.body)
             else
               { error: res.message }
             end
    end

    def weather_in_days
      avg_temp_in_days

      "#{today_avg_temp}°C e #{current_temp_desc} em #{city_name} em #{current_date}." \
        " Média para os próximos dias: #{parse_avg_text}"
    end

    def avg_temp_in_days
      @arr = []
      obj['list'].group_by { |item| Time.at(item['dt']).strftime('%m-%d-%Y') }.each do |date, data|
        avg_temp = data.sum { |info| info['main']['temp'] }
        avg_temp /= data.count
        @arr << { avg_temp: avg_temp, date: date }
      end
    end

    def today_avg_temp
      obj['list'][0]['main']['temp'].round
    end

    def city_name
      obj['city']['name']
    end

    def current_temp_desc
      obj['list'][0]['weather'][0]['description']
    end

    def current_date
      Time.now.strftime('%d/%m')
    end

    private

    def parse_avg_text
      text = ''
      @arr.last(5).each_with_index do |item, index|
        text += "#{item[:avg_temp].round(0)}°C em #{parse_date(item[:date])}"
        text += ', ' if index <= 2
        text += ' e ' if index == 3
        text += '.' if index == 4
      end
      text
    end

    def parse_date(date)
      date.gsub('-', '/').delete_suffix('/2021')
    end

    def url(city, api_id)
      URI("https://api.openweathermap.org/data/2.5/forecast?q=#{city}&appid=#{api_id}&lang=pt_br&units=metric")
    end
  end
end
