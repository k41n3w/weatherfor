# frozen_string_literal: true

require 'weatherfor/version'
require 'net/http'
require 'json'

module Weatherfor
  class Error < StandardError; end

  # Make the API request and parse data
  class ApiConsultant
    def initialize(city, api_id)
      uri = URI("https://api.openweathermap.org/data/2.5/forecast?q=#{city}&appid=#{api_id}&lang=pt_br&units=metric")
      res = Net::HTTP.get_response(uri)

      if res.code == '200'
        @json = JSON.parse res.body
      else
        { 'error' => res.message }
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
      @json['list'].group_by { |item| Time.at(item['dt']).strftime('%m-%d-%Y') }.each do |date, data|
        avg_temp = data.sum { |info| info['main']['temp'] }
        avg_temp /= 8
        arr << { avg_temp: avg_temp, date: date }
      end

      current_temp = @json['list'][0]['main']['temp']
      city_name = @json['city']['name']
      weather_description = @json['list'][0]['weather'][0]['description']
      current_date = arr.first[:date].gsub('-', '/').delete_suffix('/2021')
      text = "#{current_temp.round(0)}°C e #{weather_description} em #{city_name} em #{current_date}."

      text + " Média para os próximos dias: #{parse_avg_text(arr, text)}"
    end

    private

    def parse_avg_text(arr, text)
      arr.last(4).each_with_index do |item, index|
        text += "#{item[:avg_temp].round(0)}°C em #{item[:date].gsub('-', '/').delete_suffix('/2021')}"
        text += if index < 3
                  ', '
                else
                  '.'
                end
      end

      text
    end
  end
end
