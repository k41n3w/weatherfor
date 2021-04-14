# frozen_string_literal: true

require 'weatherfor/version'
require 'net/http'
require 'json'

module Weatherfor
  class Error < StandardError; end

  # Make the API request and parse data
  class ApiConsultant
    def initialize(city, api_id)
      uri = url(city, api_id)
      res = Net::HTTP.get_response(uri)

      if res.code == '200'
        @json = JSON.parse res.body
      else
        { 'error' => res.message }
      end
    end

    def weather_in_days
      avg_temp_in_days

      "#{today_avg_temp}°C e #{current_temp_desc} em #{city_name} em #{current_date}." \
        " Média para os próximos dias: #{parse_avg_text}"
    end

    def avg_temp_in_days
      @arr = []
      @json['list'].group_by { |item| Time.at(item['dt']).strftime('%m-%d-%Y') }.each do |date, data|
        avg_temp = data.sum { |info| info['main']['temp'] }
        avg_temp /= data.count
        @arr << { avg_temp: avg_temp, date: date }
      end
    end

    def today_avg_temp
      @arr.first[:avg_temp].round(0)
    end

    def city_name
      @json['city']['name']
    end

    def current_temp_desc
      @json['list'][0]['weather'][0]['description']
    end

    def current_date
      Time.now.strftime('%d/%m')
    end

    def parse_avg_text
      text = ''
      @arr.last(4).each_with_index do |item, index|
        text += "#{item[:avg_temp].round(0)}°C em #{parse_date(item[:date])}"
        text += index < 3 ? ', ' : '.'
      end
      text
    end

    def city
      @json['city']
    end

    def list
      @json['list']
    end

    def parse_date(date)
      date.gsub('-', '/').delete_suffix('/2021')
    end

    def url(city, api_id)
      URI("https://api.openweathermap.org/data/2.5/forecast?q=#{city}&appid=#{api_id}&lang=pt_br&units=metric")
    end
  end
end
