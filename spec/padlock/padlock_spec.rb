require "spec_helper"

describe Padlock do
  describe ".config" do
    before do
      Padlock.class_variable_set(:@@config, nil)
    end

    it "returns an OpenStruct" do
      expect( Padlock.config ).to be_a_kind_of OpenStruct
    end

    it "returns a persistant object" do
      expect( Padlock.config.random ).to be_nil
      Padlock.config.random = "value"
      expect( Padlock.config.random ).to eq "value"
    end
  end

  describe ".lock" do
    let(:object) { double(:object) }
    let(:user) { double(:user) }
    let(:padlocks) { double(:padlocks) }

    before do
      user.stub(:padlocks).and_return(padlocks)
    end

    it "unlocks the object before attempting to lock it" do
      object.should_receive(:unlock!)
      padlocks.stub(:create)
      object.stub(:reload)
      Padlock.lock(object, user)
    end

    it "creates the Padlock::Instance" do
      object.stub(:unlock!)
      padlocks.should_receive(:create).with(lockable: object)
      object.stub(:reload)
      Padlock.lock(object, user)
    end

    it "reloads the object" do
      object.stub(:unlock!)
      padlocks.stub(:create)
      object.should_receive(:reload)
      Padlock.lock(object, user)
    end
  end

  describe ".locked?" do
    let(:object) { User.create!(name: "Annie Bob") }

    it do
      object.should_receive(:locked?).and_return(true)
      expect(Padlock.locked?(object)).to be_true
    end
  end

  describe ".unlock!" do
    let(:object)  { double(:object) }

    context "single object" do
      it do
        object.should_receive(:unlock!).exactly(1).times
        Padlock.unlock!(object)
      end
    end

    context "multiple objects" do
      it do
        object.should_receive(:unlock!).exactly(2).times
        Padlock.unlock!(object, object)
      end
    end
  end

  describe ".unlocked?" do
    let(:object) { User.create!(name: "Annie Bob") }

    it do
      object.should_receive(:unlocked?).and_return(true)
      expect(Padlock.unlocked?(object)).to be_true
    end
  end

  describe ".unlock_stale" do
    let(:object) { LockableObject.create!(created_at: Time.now - 1.week, updated_at: updated_at) }
    let(:locked?) { true }
    let(:updated_at) { Time.now - 2.hours }
    let(:fake_relation) { double(:fake_relation) }

    before do
      Padlock::Instance.should_receive(:where).and_return(fake_relation)
      fake_relation.should_receive(:destroy_all)
      Padlock.unlock_stale
    end

    it "unlocks all lockables that have been locked more than 1 hour" do
      expect(object).to be_unlocked
    end
  end
end
