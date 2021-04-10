require "weatherfor/version"

module Weatherfor
  class Error < StandardError; end
  
  class WhoIs
    def self.awesome?
      puts "YOU ARE AWESOME!!"
    end
  end
end
