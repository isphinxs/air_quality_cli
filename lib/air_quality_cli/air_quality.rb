class AirQuality::AirQuality
    # attr_accessor :state, :city, :station, :data
    attr_accessor :name, :state, :aqi_value, :main_pollutant
    attr_reader :country
    
    @@all = []

    # def initialize(state, city, station)
    #     @country = "United States"
    #     @state = state
    #     @city = city
    #     @station = station
    #     save
    # end

    def initialize(name, state)
        @name = name # city
        @state = state
        @country = "United States"
        save
    end

    def save
        @@all << self
    end

    def self.all
        @@all
    end

    def add_data(aqi_value, main_pollutant)
        @aqi_value = aqi_value
        @main_pollutant = main_pollutant
    end

    def find_state
        AirQuality::State.select {|state| state.cities.include?(self)}
    end
end