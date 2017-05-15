require 'time'
require 'yaml'

# The 'handle everything' class
class TimeLapse
  def self.load_yml(path)
    config = YAML.safe_load path
    new config
  end

  def initialize(config)
    self.config = config
  end

  def call
    return :disabled unless config['enabled']
    return :paused unless during_time?
    return :already_performed if File.exist?(file_path)
    `fswebcam #{opts} #{file_path}`
    :done
  end

  def during_time?
    now >= start_at || now <= end_at || perform_at >= now
  end

  def start_at
    @start_at ||= config_date_or_default 'start_at', '00:00'
  end

  def end_at
    @end_at ||= config_date_or_default 'end_at', '23:59:59'
  end

  def minutes
    return @minutes if @minutes
    @minutes = config['minutes'].to_i
    @minutes = 1 if @minutes < 1
    @minutes
  end

  def perform_at
    return @perform_at if @perform_at
    @perform_at = start_at
    jump = minutes * 60
    @perform_at += jump while @perform_at < now
    @perform_at -= jump
  end

  def file_path
    @file_path ||= File.join file_path, file_name
  end

  def file_name
    @file_name ||= format_date(perform_at) + '.jpg'
  end

  def path
    @path ||= config['path'] || './'
  end

  def format_date(date)
    date.to_s
        .split('+')
        .first
        .gsub(/(_- )+/, '')
  end

  def config_date_or_default(key, default)
    Time.parse(config[key] || default)
  end

  def opts
    return @opts if @opts
    @opts = ''
    @opts += "-r #{config['resolution']}" if config['resolution']
    @opts += '--no-banner' unless config['no_banner']
    @opts
  end

  def now
    @now ||= Time.now
  end

  attr_accessor :config
end