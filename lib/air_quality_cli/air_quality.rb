class AirQuality::AirQuality
    # attr_accessor :state, :city, :station, :data
    attr_accessor :state, :city, :aqi_value, :main_pollutant
    attr_reader :country
    
    @@all = []

    # def initialize(state, city, station)
    #     @country = "United States"
    #     @state = state
    #     @city = city
    #     @station = station
    #     save
    # end

    def initialize(aqi_value, main_pollutant)
        @aqi_value = aqi_value
        @main_pollutant = main_pollutant
        save
    end

    def save
        @@all << self
    end

    def self.all
        @@all
    end

end