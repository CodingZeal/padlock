require "rails/generators/active_record"

module Padlock
  module Generators
    class PadlockGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_migration
        copy_file 'migration.rb', "db/migrate/create_padlocks.rb"
      end
    end
  end
end
