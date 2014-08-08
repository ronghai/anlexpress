# encoding: utf-8
require "fileutils"  
module ANLExpress
  TRACKING_FOLDER =  File.expand_path('~/.tracking')
  FileUtils.mkdir_p TRACKING_FOLDER
end