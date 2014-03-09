require "ostruct"
require "active_record"

module Padlock
  class << self
    def config
      @@config ||= OpenStruct.new(
        table_name: "padlocks",
        user_foreign_key: "user_id",
        user_class_name: "User",
        timeout: 1.day
      )
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

    def unlock_stale
      Padlock::Instance.where("updated_at >= ?", timeout).destroy_all
    end

    private

    def timeout
      Time.now - config.timeout
    end
  end
end

require "padlock/version"
require "padlock/instance"
require "padlock/lockable"
require "padlock/user"
require "padlock/integrations"
require "generators/padlock_generator"
