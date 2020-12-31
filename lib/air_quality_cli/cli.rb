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
        puts ""
        puts "Cool, pulling up the cities in #{input}."
        puts ""
        AirQuality::API.get_cities(input)
        
    end

    def check_state(input)
        if AirQuality::State.state_valid?(input)
            puts "Checking for Cities, hold tight!"
            puts ""
            true
        else 
            puts "I don't recognize that state... Please try again."
            puts ""
            puts "States should be written out (e.g., New York) not abbreviated (e.g., NY)."
            puts ""
            false
        end
    end
end