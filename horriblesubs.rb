# Setup
# Install nodejs
# Install t-get https://github.com/jeffjose/tget
#   npm install -g t-get

require 'rss'
require 'open-uri'
require 'time'
require 'fileutils'
require 'json'
require 'logger'

LOG_LOCATION = ''
LIBRARY_ROOT = ''
RESOLUTION = 720
TRACKING_FILE = ''

BASEURI = "http://horriblesubs.info/rss.php?res=#{RESOLUTION}"

logger = Logger.new(LOG_LOCATION)
json = JSON.parse(File.read(TRACKING_FILE).chomp)

TRACKING_LIST = json['shows']
LIBRARY = "#{LIBRARY_ROOT}/#{json['lib_name']}"

def series_name(filename)
  matches = /^\[HorribleSubs\]\ (.*)\ \-\ \d+\ .*\.mkv$/.match(filename)
  return nil if matches.nil?
  matches[1]
end

def file_exists_in_lib?(series, filename)
  path = "#{LIBRARY}/#{series}/#{filename}"
  File.exists? path
end

def series_exists_in_lib?(series)
  path = "#{LIBRARY}/#{series}"
  File.exists? path
end

def download_file(series, magnet)
  Dir.chdir("#{LIBRARY}/#{series}")
  command = "/usr/local/bin/tget \"#{magnet}\""
  output = `#{command}`
  $?.to_i
end

logger.info('Starting run')

open(BASEURI) do |rss|
  feed = RSS::Parser.parse(rss)
  feed.items.each do |item|
    filename = item.title
    series = series_name(filename)

    # Skip the item if we're not tracking the series
    next unless TRACKING_LIST.include?(series)

    # Make a directory for the series if it doesn't already exist
    FileUtils.mkdir_p("#{LIBRARY}/#{series}") unless File.exists?("#{LIBRARY}/#{series}")

    # Skip this episode if it already exists
    next if file_exists_in_lib?(series, filename)

    # Download the file using tget
    logger.info("Downloading file: #{filename}")
    exit_code = download_file(series, item.link)
    if exit_code != 0
      logger.error("Error while downloading file #{filename}. Cleaning up file")
      # Clean up any files that may have been created
      file_path = "#{LIBRARY}/#{series}/#{filename}"
      File.delete(file_path) if File.exists?(file_path)
    end
  end
end

logger.info('Finished run')
