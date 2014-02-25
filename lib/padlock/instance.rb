module Padlock
  class Instance < ActiveRecord::Base
    self.table_name = Padlock.config.table_name

    belongs_to :lockable, polymorphic: true
    belongs_to :user, class_name: "::#{Padlock.config.user_class_name}", foreign_key: Padlock.config.user_foreign_key
  end
end