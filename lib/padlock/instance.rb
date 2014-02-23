module Padlock
  class Instance < ::ActiveRecord::Base
    self.table_name = Padlock.config.table_name

    belongs_to :lockable, polymorphic: true
    belongs_to :user, class_name: "::User", foreign_key: "user_id"
  end
end