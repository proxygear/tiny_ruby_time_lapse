#!/usr/bin/env/ruby

require './time_lapse'

puts TimeLapse.from_yaml('./config.yml').call
