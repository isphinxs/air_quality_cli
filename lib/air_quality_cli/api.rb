class AirQuality::API
    def self.get_cities(state)
        key = ENV["AQI_API_KEY"]
        url = "http://api.airvisual.com/v2/cities?state=" + state + "&country=USA&key=" + key
        response = RestClient.get(url)
        city_array = JSON.parse(response)["data"]
        state = AirQuality::State.new(state) # temporary
        city_array.each do |city|
            new_city = AirQuality::AirQuality.new(city)
            state.add_city(new_city)
        end
    end

    def self.get_data(city)
        key = ENV["AQI_API_KEY"]
        url = "http://api.airvisual.com/v2/city?city=" + city + "&state=New%20York&country=USA&key=" + key
        response = RestClient.get(url)
        response_hash = JSON.parse(response)["data"]["current"]["pollution"]
        aqi_value = response_hash["aqius"]
        main_pollutant = response_hash["mainus"]

        AirQuality::AirQuality.new(city, aqi_value, main_pollutant)
        # response_array.each do |city|
        #     puts city["city"]
        # end
        # binding.pry
    end

end