require "spec_helper"

describe LockableObject do
  subject { LockableObject.create }

  let(:user) { User.create!(name: "Jim Bob") }

  context "when unlocked" do
    it { should_not be_locked }
    it { should be_unlocked }
    it { expect(subject.locked_by).to be_nil }
    it { expect(subject.lock_touched_at).to be_nil }
  end

  context "when locked" do
    before { user.padlock(subject) }

    it { should be_locked }
    it { should_not be_unlocked }
    it { expect(subject.locked_by).to eq user }
    it { expect(subject.lock_touched_at).to_not be_nil }
  end
end
