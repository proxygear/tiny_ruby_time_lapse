#!/usr/bin/env ruby

require './src/time_lapse'

puts TimeLapse.from_config_file('./config.yml').call
