#!/usr/bin/env ruby

require_relative './src/time_lapse.rb'

begin
  config_path = File.join File.dirname(__FILE__), 'config.yml'
  res = TimeLapse.from_config_file(config_path).call
  File.open('./script.log', 'a') {|f| f.write "#{Time.now}: OK - #{res}\n" }
  puts res
rescue Exception => e
  File.open('./script.log', 'a') {|f| f.write "#{Time.now}: #{e.message}\n" }
  raise e
end
