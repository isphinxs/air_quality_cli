class AirQuality::CLI
    def call
        puts ""
        puts "Welcome to the Air Quality CLI application!"
        puts ""
        AirQuality::API.get_states
        start
    end

    def user_input
        input = gets.strip
        if input == "exit"
            puts ""
            puts "Okay, thanks for coming! Bye!"
            exit
        else
            input
        end
    end

    def start
        puts "What state would you like to view (e.g., Arizona)?"
        puts ""
        input = user_input 
        while !check_state(input)
            input = user_input
        end

        puts "Cool, pulling up the cities in #{input}."
        puts ""
        AirQuality::API.get_cities(input)
        puts "Which city are you looking for? Choose from the following:"
        puts ""
        AirQuality::City.find_cities_by_state(input).each do |city|
            puts city.name
        end
        puts ""
        
        input = user_input
        while !check_city(input)
            input = user_input
        end
        puts "end of input"

    end

    def check_state(input)
        if AirQuality::State.state_valid?(input)
            puts ""
            puts "Checking for Cities, hold tight!"
            true
        else 
            puts ""
            puts "I don't recognize that state... Please try again."
            puts "States should be written out (e.g., New York) not abbreviated (e.g., NY)."
            puts ""
            false
        end
    end

    def check_city(input)
        if AirQuality::City.city_valid?(input)
            puts ""
            puts "Great, pulling air quality data for #{input}."
            puts ""
            true
        else
            puts ""
            puts "I don't recognize that city... Please try again."
            puts "Choose one of the cities listed above."
            puts ""
            false
        end
    end
end