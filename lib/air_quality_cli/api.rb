class AirQuality::API
    def self.get_states
        key = ENV["AQI_API_KEY"]
        url = "http://api.airvisual.com/v2/states?country=USA&key=" + key
        response = RestClient.get(url)
        state_array = JSON.parse(response)["data"]
        state_array.each do |state|
            new_state = AirQuality::State.new(state["state"])
        end
        AirQuality::State.all
    end

    def self.get_cities(state)
        key = ENV["AQI_API_KEY"]
        url = "http://api.airvisual.com/v2/cities?state=" + state + "&country=USA&key=" + key
        response = RestClient.get(url)
        city_array = JSON.parse(response)["data"]
        # state = AirQuality::State.new(state) # temporary
        state_object = AirQuality::State.find_state(state)
        city_array.each do |city|
            new_city = AirQuality::City.new(city["city"], state_object)
            # state.add_city(new_city)
        end
        state_object
    end

    def self.get_city_air_quality(city)
        key = ENV["AQI_API_KEY"]

        city_object = AirQuality::City.find_city(city) # temporary
        state = city_object.state.state_name # temporary
        
        url = "http://api.airvisual.com/v2/city?city=" + city + "&state=" + state + "&country=USA&key=" + key
        
        begin 
          response = RestClient.get(url)
        rescue
            aqi_value = nil
            main_pollutant = nil
        else
            response_hash = JSON.parse(response)["data"]["current"]["pollution"]
            aqi_value = response_hash["aqius"]
            main_pollutant = response_hash["mainus"]
        end

        # AirQuality::AirQuality.new(city, aqi_value, main_pollutant)
        
        city_object.add_data(aqi_value, main_pollutant)
        city_object
        # response_array.each do |city|
        #     puts city["city"]
        # end
        # binding.pry
    end

end