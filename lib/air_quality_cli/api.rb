class AirQuality::API
    def self.get_data
        key = ENV["AQI_API_KEY"]
        url = "http://api.airvisual.com/v2/cities?state=New%20York&country=USA&key=" + key
        response = RestClient.get(url)
        response_array = JSON.parse(response)
        # binding.pry
    end
end