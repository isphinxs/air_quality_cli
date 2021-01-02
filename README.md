# Air Quality CLI Application

This is a CLI application that shows the air quality of a given city and state. It uses JSON and RestClient gems to retrieve data from the [IQAir API](https://www.iqair.com/air-pollution-data-api). The app makes new instances of State and City classes to represent the data, and makes the data visible to users through an interactive CLI app.

The CLI app uses the [dotenv](https://github.com/bkeepers/dotenv) gem to safeguard the API key. Replace "ENV[AQI_API_Key]" in the API call with your own key from IQAir to make this app work locally.

## Usage

Users can provide a state and select from cities with available air quality data in the US. They can also view more information about air quality levels.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/isphinxs/air_quality_cli. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/isphinxs/air_quality_cli/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Air Quality CLI project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/isphinxs/air_quality_cli/blob/main/CODE_OF_CONDUCT.md).
