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
        if input.downcase == "exit" || input.downcase == "n" || input.downcase == "no"
            puts ""
            puts "Okay, thanks for coming! Bye!"
            puts ""
            exit
        else
            input
        end
    end

    def start
        pull_data

        puts "Would you like to check another city or state?"
        puts ""
        input = user_input
        while input.downcase == "yes" || input.downcase == "y"
            puts ""
            # pull_data
            start
        end
    end

    def pull_data
        puts "What state would you like to view (e.g., Arizona)?"
        puts "You can also type 'exit' to exit."
        puts ""

        input = user_input 
        while !check_state(input)
            input = user_input
        end
        puts ""

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
        puts ""
        
        print_air_quality(input)
    end

    def check_state(input)
        if AirQuality::State.state_valid?(input)
            # puts ""
            # puts "Checking for Cities, hold tight!"
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
            true
        else
            puts ""
            puts "I don't recognize that city... Please try again."
            puts "Choose one of the cities listed above."
            puts ""
            false
        end
    end

    def print_air_quality(input)
        city_object = AirQuality::API.get_city_air_quality(input)
        pollutant = main_pollutant(city_object)
        pollution_level = pollution_level(city_object)
        value = pollution_level[0]
        concern_level = pollution_level[1]
        detail = pollution_level[2]

        puts ""
        puts "Awesome! Here is the air quality data for #{input}:"
        puts ""
        puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        puts "The main pollutant is #{pollutant}."
        puts "The pollution level is #{value}."
        puts "This level is considered #{concern_level}."
        puts "#{detail}"
        puts "You can read more about air pollution at https://www.airnow.gov/."
        puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        puts ""
    end

    def main_pollutant(city_object)
        case city_object.main_pollutant
        when "p2"
            "particle pollution, PM 2.5"
        when "p1"
            "particle pollution, PM 10"
        when "o3"
            "Ozone (O3)"
        when "n2"
            "Nitrogen dioxide (NO2)"
        when "s2"
            "Sulfur dioxide (SO2)"
        when "co"
            "Carbon monoxide (CO)"
        end
    end
    
    def pollution_level(city_object)
        level = city_object.aqi_value.to_i
        case level
        when 0..50
            [level, "good", "Air quality is satisfactory, and air pollution poses little or no risk."]
        when 51..100
            [level, "moderate", "Air quality is acceptable. However, there may be a risk for some people, particularly those who are unusually sensitive to air pollution."]
        when 101..150
            [level, "unhealthy for Sensitive Groups", "Members of sensitive groups may experience health effects. The general public is less likely to be affected."]
        when 151..200
            [level, "unhealthy", "Some members of the general public may experience health effects; members of sensitive groups may experience more serious health effects."]
        when 201..300
            [level, "very Unhealthy", "Health alert: The risk of health effects is increased for everyone."]
        else
            [level, "hazardous", "Health warning of emergency conditions: everyone is more likely to be affected."]
        end
    end
end