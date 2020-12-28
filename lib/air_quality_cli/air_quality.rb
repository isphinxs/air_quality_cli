class AirQuality::AirQuality
    attr_accessor :state, :city, :station, :data
    attr_reader :country
    
    @@all = []

    def initialize(state, city, station)
        @country = "United States"
        @state = state
        @city = city
        @station = station
        save
    end

    def save
        @@all << self
    end

    def self.all
        @@all
    end

end