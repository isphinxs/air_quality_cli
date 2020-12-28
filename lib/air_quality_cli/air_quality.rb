class AirQuality::AirQuality
    attr_accessor :state, :city, :station, :data
    attr_reader :country
    
    def initialize
        @country = "United States"
    end
end