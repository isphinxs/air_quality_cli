class AirQuality::State
    attr_accessor :state
    attr_reader :city
    
    @@all = []
    
    def initialize(state)
        @state = state
        @city = []
        save
    end

    def save
        @@all << self
    end

    def self.all
        @@all
    end

    def add_city(city)
        self.city << city
    end
end