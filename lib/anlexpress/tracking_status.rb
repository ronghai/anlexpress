# encoding: utf-8
require 'anlexpress/base'
require 'yaml'
require 'date'
module ANLExpress 
  class TrackingStatus
    attr_accessor :tracking_number, :update, :carrier
    attr_reader :status
    
    def initialize(ta)
      @tracking_number = ta
      @status=[]
    end

    def add_status(date, note)
      @status.push([date, note])
    end
    
    def to_yaml_properties
      ["@tracking_number", "@status", "@carrier"]
    end
    
    def to_s
      s = ""
      s <<  @tracking_number.to_s << ":\n"
      @status.each{|v| 
        s << v[0].to_s << ":" << v[1] << "\n"
      }
    end
    def == (other)
      other.class == self.class && @tracking_number == other.tracking_number && @status == other.status
    end
    
    def update?
      @update
    end
    
    def update_status!
      file = "#{TRACKING_FOLDER}/#{@tracking_number}.#{@carrier.code}.yaml"
      begin
          old_tracking =  YAML.load(File.open(file, "rb").read)
      rescue
      end
      if self != old_tracking
        File.open(file, 'w') { |file| file.write(self.to_yaml)}
      end
      yield(self,self != old_tracking)  if block_given?
      @update = self != old_tracking
    end
    
    def self.create_statues delegate, *track_numbers, &block
      tracking_status = delegate.create_statues(track_numbers)
      update_status!(*tracking_status, &block)
      tracking_status
    end
    
    private
    def self.update_status! *tracking_status,&block
      tracking_status.each{|x|
        x.update_status! &block
      }
    end
    
  end

end