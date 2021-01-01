class AirQuality::State
    attr_accessor :state_name
    
    @@all = []
    
    def initialize(state)
        @state_name = state
        save
    end

    def save
        @@all << self
    end

    def self.all
        @@all
    end

    def self.find_state(state)
        self.all.detect {|state_object| state_object.state_name == state}
    end

    def self.state_valid?(state)
        self.find_state(state) ? true : false
    end
end