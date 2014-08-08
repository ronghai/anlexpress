require 'helper'

class TestAnlexpress < Test::Unit::TestCase
  ANLExpress::TrackingStatus.create_statues(ANLExpress::ANLExpress.new, 80000025171,80000025172){|x|puts x.to_yaml}
end
