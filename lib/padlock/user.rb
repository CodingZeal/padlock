module Padlock
  module User
    extend ActiveSupport::Concern

    included do
      has_many :padlocks, class_name: "Padlock::Instance", foreign_key: Padlock.config.user_foreign_key
    end

    def padlock *objects
      Padlock.lock(self, *objects)
    end

    def padlock! *objects
      objects.each do |object|
        if object.unlocked?
          Padlock.lock(self, object)
        else
          raise "Attempting to lock an object that is already locked"
        end
      end
    end

    def locked? object
      self.padlocks.include? object
    end

    def touch *objects
      objects.each do |object|
        if object.locked_by? self
          object.updated_at = Time.now
          object.save
        end
      end
    end
  end
end
