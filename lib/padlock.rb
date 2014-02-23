require "ostruct"
require "active_record"

module Padlock
  class << self
    def config
      @@config ||= OpenStruct.new( table_name: "padlocks" )
    end

    def lock(object, user)
      unlock!(object)
      user.padlocks.create(lockable: object)
      object.reload
    end

    def locked? object
      object.locked?
    end

    def unlock! *objects
      objects.each { |object| object.unlock! }
    end

    def unlocked? object
      object.unlocked?
    end
  end
end

require "padlock/version"
require "padlock/instance"
require "padlock/lockable"
require "padlock/user"
# require "padlock/integrations/active_record"