require 'nokogiri'
require 'open-uri'

class Weather
  def display
    "Current Conditions: #{conditions}, #{temperature} #{unit_symbol}"
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
    94105
  end

  def unit
    'f'
  end

  def unit_symbol
    #"\u2109"
    "\u00B0#{unit.upcase}"
  end
end

yahoo_weather = Weather.new
puts yahoo_weather.display