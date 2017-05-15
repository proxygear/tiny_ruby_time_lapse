#!/usr/bin/env ruby

require './src/time_lapse'

begin
  res = TimeLapse.from_config_file('./config.yml').call
  File.open('./script.log', 'a') {|f| f.write "#{Time.now}: OK - #{res}\n" }
  puts res
rescue Exception => e
  File.open('./script.log', 'a') {|f| f.write "#{Time.now}: #{e.message}\n" }
  raise e
end
