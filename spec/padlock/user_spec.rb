require "spec_helper"

describe User do
  let(:object) { double(:object) }
  subject { User.create!(name: "Jimmy John") }

  describe "#padlock" do

    it "delegates to Padlock.lock" do
      Padlock.should_receive(:lock)
      subject.padlock(object)
    end

    it "accepts multiple objects" do
      Padlock.stub(:lock)
      subject.padlock(object, object)
    end
  end

  describe "#padlock!" do
    context "when unlocked" do
      before do
        object.stub(:unlocked?).and_return(true)
      end

      context "with a single object" do
        it "delegates to Padlock.lock" do
          Padlock.should_receive(:lock).with(subject, object).exactly(1).times
          subject.padlock!(object)
        end
      end

      context "with multiple objects" do
        it "delegates to Padlock.lock for each object" do
          Padlock.should_receive(:lock).with(subject, object).exactly(2).times
          subject.padlock!(object, object)
        end
      end
    end
  end

  describe "#locked?" do
    before { subject.stub_chain(:padlocks, :include?).and_return(include?) }

    context "when included" do
      let(:include?) { true }
      it { expect(subject.locked?(object)).to eq true }
    end

    context "when not included" do
      let(:include?) { false }
      it { expect(subject.locked?(object)).to eq false }
    end
  end
end
