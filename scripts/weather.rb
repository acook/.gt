require 'nokogiri'
require 'open-uri'
require 'json'

module YahooWeather
  class << self
    def display
      "#{conditions}, #{temperature}#{unit_symbol}" + (show_location? ? "in #{location}" : '')
    end

    def url
      url_for_site % { zip_code: zip_code, unit: unit}
    end

    protected

    def parse
      doc = Nokogiri::XML get
      item = doc.css('rss channel item')
      item.children.find {|node| node.name == 'condition'}
    end

    def conditions
      weather.attributes['text'].value
    end

    def temperature
      weather.attributes['temp'].value
    end

    def weather reload = false
      unless reload || !@weather then
        @weather
      else
        @weather = parse
      end
    end

    def get
      open url
    end

    def url_for_site
      'http://xml.weather.yahoo.com/forecastrss?p=%{zip_code}&u=%{unit}'
    end

    def zip_code
      get_zip || 94105
    end

    def show_location?
      false
    end

    def location
      get_location || 'San Francisco'
    end

    def unit
      'f'
    end

    def unit_symbol
      "\u2109"
      #"\u00B0#{unit.upcase}"
    end

    def get_zip
      zipcode = geocode['zipcode']
      zipcode.empty? ? nil : zipcode
    end

    def get_location
      "#{geocode['city']}, #{geocode['region_code']}" if get_zip
    end

    def geocode
      @geocode ||= JSON.parse open('http://freegeoip.net/json/').read
    end

    def ip
      open('http://ifconfig.me/ip').read.chomp
    end
  end
end

puts YahooWeather.display
