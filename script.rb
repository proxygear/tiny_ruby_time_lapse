#!/usr/bin/env ruby

require './time_lapse'

puts TimeLapse.load_yaml('./config.yml').call
