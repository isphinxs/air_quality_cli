require "dotenv/load"

require_relative "./air_quality_cli/version"
require_relative "./air_quality_cli/city"
require_relative "./air_quality_cli/api"
require_relative "./air_quality_cli/cli"
require_relative "./air_quality_cli/state"

require "bundler"
Bundler.require

# puts "in environment"
