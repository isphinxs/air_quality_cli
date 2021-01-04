class AirQuality::CLI
    def call
        puts ""
        puts Rainbow("Welcome to the Air Quality CLI application!").bright
        puts ""
        start
    end

    def user_input
        input = gets.strip
        if input.downcase == "exit" || input.downcase == "n" || input.downcase == "no"
            puts ""
            puts "Okay, thanks for coming! Bye!"
            puts ""
            exit
        elsif input.downcase == "help"
            puts ""
            puts "***"
            puts ""
            puts Rainbow("Info about Air Quality").bright
            puts ""
            puts "The air quality data is from IQAir (https://www.iqair.com/air-pollution-data-api) and is categorized by AQI."
            puts "The Air Quality Index (AQI) estimates how clean and healthy air is, based on the following scale:"
            puts ""
            puts Rainbow("AQI 0-50: Good").green
            puts Rainbow("AQI 51-100: Moderate").yellow
            puts Rainbow("AQI 101-150: Unhealthy for sensitive groups").orange
            puts Rainbow("AQI 151-200: Unhealthy").red
            puts Rainbow("AQI 201-300: Very Unhealthy").purple
            puts Rainbow("AQI 301+: Hazardous").maroon
            puts ""
            puts Rainbow("Info about User Inputs").bright
            puts ""
            puts "You can always type 'exit' to exit. Otherwise, provide a city and state where prompted to learn more about the air quality in that region."
            puts ""
            puts "***"
            puts ""
            start
        else
            input
        end
    end

    def start
        if AirQuality::State.all.length < 1
            if AirQuality::API.get_states == "Error"
                handle_error
            end
        end

        pull_data

        puts "Would you like to check another city or state?"
        puts ""
        input = user_input

        until input.downcase == "yes" || input.downcase == "y"
            puts ""
            puts "I'm sorry, I don't understand. Type yes, no, or exit."
            puts ""
            input = user_input
        end
        puts ""
        start
    end

    def pull_data
        puts "What state would you like to view (e.g., Arizona)?"
        puts "You can also type 'exit' to exit or 'help' for more info."
        puts ""

        input = user_input 
        input = AirQuality::State.check_case_and_abbreviation(input)
        while !check_state(input)
            input = user_input
            input = AirQuality::State.check_case_and_abbreviation(input)
        end
        puts ""

        if AirQuality::State.find_state(input).cities.length < 1
            puts "Cool, pulling up the cities in #{input}."
            puts ""
            if AirQuality::API.get_cities(input) == "Error"
                handle_error
            end
        end
        print_cities(input)
    end

    def print_cities(input)
        AirQuality::City.clear_current_cities
        puts "Which city are you looking for? Choose from the following (enter a number or city name):"
        puts ""
        counter = 1
        AirQuality::City.find_cities_by_state(input).each do |city|
            if counter % 2 == 0
                puts Rainbow("#{counter}. #{city.name}").inverse 
            else 
                puts "#{counter}. #{city.name}"
            end
            AirQuality::City.current_city_list << city.name
            counter += 1
        end
        puts ""
        
        input = user_input
        input = AirQuality::City.find_city_name(input)
        while !check_city(input)
            input = user_input
        end
        input = AirQuality::City.find_city_name(input)
        puts ""
        
        print_air_quality(input)
    end

    def check_state(input)
        if AirQuality::State.state_valid?(input)
            true
        else 
            puts ""
            puts "I don't recognize that state... Please try again."
            puts "States should be written out (e.g., New York) or abbreviated (e.g., NY)."
            puts ""
            false
        end
    end

    def check_city(input)
        if AirQuality::City.city_valid?(input)
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

        if pollutant
            value = pollution_level[0]
            concern_level = pollution_level[1]
            detail = pollution_level[2]
            color = pollution_level[3].to_sym

            puts "Awesome! Here is the air quality data for #{input}:"
            puts ""
            puts Rainbow("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~").color(color)
            puts Rainbow("The main pollutant is #{pollutant}.").color(color)
            puts Rainbow("The pollution level is #{value}.").color(color)
            puts Rainbow("This level is considered #{concern_level}.").color(color)
            puts Rainbow("#{detail}").color(color)
            puts Rainbow("You can read more about air pollution at https://www.airnow.gov/, or type 'help' for more info.").color(color)
            puts Rainbow("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~").color(color)
            puts ""
        else
            puts "I'm sorry, data isn't available for that city!"
            puts "Please choose another city."
            puts ""

            input = user_input
            while !check_city(input)
                input = user_input
            end
            puts ""
            
            print_air_quality(input)
        end
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
            [level, "good", "Air quality is satisfactory, and air pollution poses little or no risk.", "green"]
        when 51..100
            [level, "moderate", "Air quality is acceptable. However, there may be a risk for some people, particularly those who are unusually sensitive to air pollution.", "yellow"]
        when 101..150
            [level, "unhealthy for Sensitive Groups", "Members of sensitive groups may experience health effects. The general public is less likely to be affected.", "orange"]
        when 151..200
            [level, "unhealthy", "Some members of the general public may experience health effects; members of sensitive groups may experience more serious health effects.", "red"]
        when 201..300
            [level, "very Unhealthy", "Health alert: The risk of health effects is increased for everyone.", "purple"]
        else
            [level, "hazardous", "Health warning of emergency conditions: everyone is more likely to be affected.", "maroon"]
        end
    end

    def handle_error
        puts "Hmm, there seems to be an issue with the API. Do you want to try again?"
        puts "" 
        input = user_input
        puts ""

        until input.downcase == "yes" || input.downcase == "y"
            puts ""
            puts "I'm sorry, I don't understand. Type yes or no."
            puts "You can also type 'exit' to exit or 'help' for more info."
            puts ""
            input = user_input
        end
        start
    end

end