require 'spec_helper'

describe ArchiveUser do
  subject { described_class.new(User.new) }
  let!(:user) { User.new }

  describe '#commence!' do
    it 'sets archived_at field to time now' do
      expect(subject.archive).to be_within(1.second).of(Time.zone.now)
    end
    it 'deletes user skills' do
      expect(subject.delete_skills).to eq([])
    end
    it 'saves user' do
      subject.commence!
    end
  end
end
