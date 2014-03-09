require "spec_helper"

describe LockableObject do
  subject { LockableObject.create }

  let(:user) { User.create!(name: "Jim Bob") }

  context "when unlocked" do
    its(:locked?)   { should be_false }
    its(:unlocked?) { should be_true }
    its(:locked_by) { should be_nil }
    its(:lock_touched_at) { should be_nil }
  end

  context "when locked" do
    before { user.padlock(subject) }

    its(:locked?)   { should be_true }
    its(:unlocked?) { should be_false }
    its(:locked_by) { should == user }
    its(:lock_touched_at) { should_not be_nil }

  end
end
