require 'rails_helper'

describe AskForSupport do

  subject { described_class.new(User.new, Topic.new, {}) }
  let(:user) { User.new }

  describe '#commence!' do
    before do
      allow(subject).to receive(:supporter).and_return(user)
      allow(subject).to receive(:deliver_email).and_return(true)
    end

    it "should save new_support" do
      expect(subject.new_support).to receive(:save!)
      subject.commence!
    end

    it "should send email out" do
      allow(subject.new_support).to receive(:save!)
      expect(subject).to receive(:deliver_email)
      subject.commence!
    end
  end
end
