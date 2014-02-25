module Padlock
  module ActiveRecord
    def acts_as_padlock_user(opts={})
      Padlock.config.user_class_name  = self.name
      Padlock.config.user_foreign_key = opts[:foreign_key] if opts[:foreign_key].present?

      class_eval { include Padlock::User }
    end
  end
end

ActiveRecord::Base.send :extend, Padlock::ActiveRecord