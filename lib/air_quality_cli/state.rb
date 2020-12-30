class AirQuality::State
    attr_accessor :state, :city
    
    def initialize(state)
        @state = state
        save
    end

    def save
        @@all << self
    end

    def self.all
        @@all
    end

end