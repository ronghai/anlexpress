# encoding: utf-8
require 'anlexpress/tracking_status'
require 'net/http'
require 'nokogiri'
require 'date'
PROXY_ADDR = '172.17.51.240'
PROXY_PORT = 8080 
module ANLExpress
  class ANLExpress
    attr_reader :domain, :path, :code
    def initialize 
      @domain = 'www.anlexpress.com'
      @path = "/chaxun.php"
      @code = 'ANL'
    end
    
    def create_statues *track_numbers
      parse_status(package_status(track_numbers))
    end
    
    
    private
    def package_status *track_numbers
      Net::HTTP.new(@domain, nil, PROXY_ADDR, PROXY_PORT).start { |http|
        res = http.post(@path, "zi=#{track_numbers.join(',')}")
        return res.body
      }
    end
    
    def parse_status html
      doc = Nokogiri::HTML(html)
      trackings = []
      doc.css('td.zi14 > span.zi1452').each do |something|
        tra = TrackingStatus.new(something.text)
        something.parent.parent.parent.css('td.zi12-66').each do |more|
          dt = more.children[0].text.gsub("\u00A0", "").strip
          note = more.children[1].text.gsub("\u00A0", "").strip
          tra.add_status(DateTime.strptime(dt, '%Y-%m-%d %H:%M:%S'), note)
          tra.carrier = self
        end
        trackings.push(tra)
      end
      trackings
    end
  end

end