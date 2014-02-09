require "ostruct"
require "active_record"
require "padlock/version"
require "padlock/lock"
require "padlock/instance"

module Padlock
  class << self
    def current_user=(method)
      if method.is_a? Symbol
        Padlock.config.current_user = method
      else
        raise "Padlock#current_user= is expecting a symbol"
      end
    end

    def config
      @@config ||= OpenStruct.new
    end
  end
end