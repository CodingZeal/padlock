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
      Padlock.lock(user, object)
    end

    it "creates the Padlock::Instance" do
      object.stub(:unlock!)
      padlocks.should_receive(:create).with(lockable: object)
      object.stub(:reload)
      Padlock.lock(user, object)
    end

    it "reloads the object" do
      object.stub(:unlock!)
      padlocks.stub(:create)
      object.should_receive(:reload)
      Padlock.lock(user, object)
    end

    it "accepts a splat of objects" do
      object.should_receive(:unlock!).exactly(2).times
      padlocks.should_receive(:create).exactly(2).times
      object.should_receive(:reload).exactly(2).times
      Padlock.lock(user, object, object)
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

  describe ".touch" do
    let(:object) { LockableObject.create }
    let(:locked?) { true }
    let(:fake_padlock) { double(:fake_padlock) }

    before do
      object.stub(:locked?).and_return(locked?)
      object.stub(:padlock).and_return(fake_padlock)
    end

    context "when locked" do
      let(:locked?) { true }

      it "sets a new value on the updated_at column and saves it" do
        expect(object).to receive(:updated_at=)
        expect(object).to receive(:save)
        Padlock.touch(object)
      end
    end

    context "when unlocked" do
      let(:locked?) { false }

      it "leaves the object uneffected" do
        expect(object).to_not receive(:updated_at=)
        expect(object).to_not receive(:save)
        Padlock.touch(object)
      end
    end
  end
end
