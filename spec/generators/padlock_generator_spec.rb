require "spec_helper"

describe Padlock::Generators::PadlockGenerator, type: :generator do
  destination File.expand_path("../../tmp", __FILE__)

  before do
    prepare_destination
    run_generator
  end

  it "has generated the migration file" do
    destination_root.should have_structure {
      directory "db" do
        directory "migrate" do
          file "create_padlocks.rb" do
            contains "class CreatePadlocks"
          end
        end
      end
    }
  end
end
