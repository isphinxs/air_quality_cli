class AirQuality::City
    attr_accessor :name, :state, :aqi_value, :main_pollutant
    attr_reader :country
    
    @@all = []
    @@current_city_list = []

    def initialize(name, state)
        @name = name 
        @state = state
        @country = "USA"
        state.cities << self
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

    def self.find_city_name(input)
        if input.to_i > 0
            self.city_by_number(input.to_i)
        else 
            self.check_case(input)
        end
    end

    def self.find_city(name)
        self.all.detect {|city| city.name == name}
    end

    def self.find_cities_by_state(state)
        self.all.select {|city| city.state.state_name == state}
    end

    def self.city_valid?(city)
        self.find_city_name(city) ? true : false
    end

    def self.current_city_list
        @@current_city_list
    end

    def self.clear_current_cities
        @@current_city_list.clear
    end

    def self.city_by_number(number)
            self.current_city_list[number.to_i - 1]
    end

    def self.check_case(city)
        if city.split(" ").length > 1 
            city.split(" ").collect {|word| word.capitalize}.join(" ")
        elsif city.split("-").length > 1
            city.split("-").collect {|word| word.capitalize}.join("-")
        else
            city.capitalize
        end
    end
end