# frozen_string_literal: true

RSpec.describe Weatherfor do
  it 'has a version number' do
    expect(Weatherfor::VERSION).not_to be nil
  end

  context '#ApiConsultant', :vcr do
    context 'with correct token' do
      city_name = 'Caconde'
      let(:request_api) do
        VCR.use_cassette('weatherfor/initialize_api') do
          Weatherfor::ApiConsultant.new(city_name, '09b0fa85cf2627ed64bb823a7e79d5bb')
        end
      end

      it '#request_api' do
        expect(request_api.obj['cod']).to eq('200')
        expect(request_api.obj['message']).to eq(0)
        expect(request_api.obj['cnt']).to eq(40)
        expect(request_api.obj['list'].count).to eq(40)
      end

      it '#weather_in_days' do
        expect(request_api.weather_in_days).to eq(
          "21°C e chuva leve em Caconde em #{Time.now.strftime('%d/%m')}." \
          ' Média para os próximos dias: 19°C em 04/18, 19°C em 04/19, 18°C em 04/20, 18°C em 04/21 e 17°C em 04/22.'
        )
      end

      it '#avg_temp_in_days' do
        expect(request_api.avg_temp_in_days['04-17-2021'].count).to eq(3)
        expect(request_api.avg_temp_in_days['04-18-2021'].count).to eq(8)
        expect(request_api.avg_temp_in_days['04-19-2021'].count).to eq(8)
        expect(request_api.avg_temp_in_days['04-20-2021'].count).to eq(8)
        expect(request_api.avg_temp_in_days['04-21-2021'].count).to eq(8)
        expect(request_api.avg_temp_in_days['04-22-2021'].count).to eq(5)
      end

      it '#today_avg_temp' do
        expect(request_api.today_avg_temp).to be_a(Integer)
        expect(request_api.today_avg_temp).to eq(21)
        expect(request_api.today_avg_temp).not_to be_nil
      end

      it '#city_name' do
        expect(request_api.city_name).to be_a(String)
        expect(request_api.city_name).not_to be_nil
        expect(request_api.city_name).to eq(city_name)
      end

      it '#current_temp_desc' do
        expect(request_api.current_temp_desc).to be_a(String)
        expect(request_api.current_temp_desc).not_to be_nil
        expect(request_api.current_temp_desc).to eq('chuva leve')
      end

      it '#current_date' do
        expect(request_api.current_date).to be_a(String)
        expect(request_api.current_date).not_to be_nil
        expect(request_api.current_date).to eq(Time.now.strftime('%d/%m'))
      end
    end

    context 'with incorrect token' do
      let(:request_api_wrong_token) do
        VCR.use_cassette('weatherfor/initialize_wrong_token') do
          Weatherfor::ApiConsultant.new('Caconde', 'wrong')
        end
      end

      it '#request_api_wrong_token' do
        expect(request_api_wrong_token.obj).to eq({ error: 'Unauthorized' })
      end
    end
  end
end
