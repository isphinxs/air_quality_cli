class AirQuality::API
    def self.get_cities(state)
        key = ENV["AQI_API_KEY"]
        url = "http://api.airvisual.com/v2/cities?state=" + state + "&country=USA&key=" + key
        response = RestClient.get(url)
        city_array = JSON.parse(response)["data"]
        state = AirQuality::State.new(state) # temporary
        city_array.each do |city|
            new_city = AirQuality::AirQuality.new(city["city"], state)
            # state.add_city(new_city)
        end
        state
    end

    def self.get_data(city)
        key = ENV["AQI_API_KEY"]

        city_object = AirQuality::AirQuality.find_city(city) # temporary
        state = city_object.state.state_name # temporary
        
        url = "http://api.airvisual.com/v2/city?city=" + city + "&state=" + state + "&country=USA&key=" + key
        response = RestClient.get(url)
        response_hash = JSON.parse(response)["data"]["current"]["pollution"]
        aqi_value = response_hash["aqius"]
        main_pollutant = response_hash["mainus"]

        # AirQuality::AirQuality.new(city, aqi_value, main_pollutant)
        
        city_object.add_data(aqi_value, main_pollutant)
        city_object
        # response_array.each do |city|
        #     puts city["city"]
        # end
        # binding.pry
    end

end