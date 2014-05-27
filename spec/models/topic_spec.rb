require 'spec_helper'

describe Topic do
  subject { described_class.new }

  let!(:topic1) { Topic.create(title: 'title') }
  let!(:topic2) { Topic.create }
  let!(:user1) { User.create }
  let!(:skill1) { Skill.create(user_id: user1.id, topic_id: topic1.id) }

  describe '#to_s' do
    context 'when title is present' do
      it 'returns title' do
        expect(topic1.to_s).to eq(topic1.title)
      end
    end

    context 'when title is not present' do
      it 'returns nil' do
        expect(topic2.to_s).to be nil
      end
    end
  end

  describe '#users_count' do
    context 'when there are users' do
      it 'returns a number greater than 0' do
        expect(topic1.users_count).to eq(topic1.skills_count)
      end
    end

    context 'when there are no users' do
      it 'returns 0' do
        expect(topic2.users_count).to eq(topic2.skills_count)
      end
    end
  end
end
