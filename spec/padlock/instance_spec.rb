require "spec_helper"

describe Padlock::Instance do
  let(:user)   { User.create!(name: "Jim Bob") }
  let(:object) { User.create!(name: "Annie Bob") }

  subject { Padlock::Instance.new(lockable: object, user: user) }

  it { should be_a_kind_of ActiveRecord::Base }

  its(:user) { should == user }
  its(:lockable) { should == object }
end