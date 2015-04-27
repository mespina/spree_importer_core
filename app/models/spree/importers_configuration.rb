module Spree
  class ImportersConfiguration < Preferences::Configuration
    attr_accessor :importers

    def initialize
      @importers = []
    end
  end
end
