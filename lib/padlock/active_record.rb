module Padlock
  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_padlock_user(opts={})
        options = {
          class_name: self.name
        }.update(opts)
      end
    end
  end
end