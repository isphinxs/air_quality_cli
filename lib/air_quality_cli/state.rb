class AirQuality::State
    attr_accessor :state_name
    attr_reader :cities
    
    @@all = []
    
    def initialize(state)
        @state_name = state
        @cities = []
        save
    end

    def save
        @@all << self
    end

    def self.all
        @@all
    end

    def add_city(city)
        self.cities << city
    end
end