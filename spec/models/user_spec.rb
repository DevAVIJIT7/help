require 'spec_helper'

describe User do
  subject {  described_class.new }

  let!(:user1) { User.create(email: 'root@root.pl') }
  let!(:user2) { User.create(email: 'root@root.pl') }
  let!(:support1) { Support.create(user_id: user1.id, receiver_id: user1.id, done: false) }
  let!(:support2) { Support.create(user_id: user2.id, receiver_id: user2.id, done: true) }

  describe '#name' do
    context 'when first and last name are valid' do
      it 'returns first and last name' do
        subject.first_name = 'first'
        subject.last_name = 'last'
        expect(subject.name).to eq('first last')
      end
    end

    context 'when first name is valid and last is not' do
      it 'returns first name' do
        subject.first_name = 'first'
        expect(subject.name).to eq('first')
      end
    end

    context 'when last name is valid and first is not' do
      it 'returns last name' do
        subject.last_name = 'last'
        expect(subject.name).to eq('last')
      end
    end

    context 'when first and last name are not valid' do
      it 'returns nothing' do
        expect(subject.name).to eq('')
      end
    end
  end

  describe '#to_s' do
    context 'when name is valid' do
      it 'returns name' do
        subject.first_name = 'first'
        subject.last_name = 'last'
        expect(subject.to_s).to eq('first last')
      end
    end

    context 'when name is valid' do
      it 'returns name' do
        expect(subject.to_s).to eq('')
      end
    end
  end

  describe '#pending_supports_count' do
    context 'has no supports' do
      it 'returns zero' do
        expect(subject.pending_supports_count).to eq(0)
      end
    end

    context 'has only done supports' do
      it 'returns zero' do
        expect(user2.pending_supports_count).to eq(0)
      end
    end

    context 'has not done supports' do
        it 'returns a number' do
        expect(user1.pending_supports_count).to eq(user1.supports.not_done.count)
      end
    end
  end

  describe '#has_pending_supports?' do
    context 'has pending supports' do
      it 'returns true' do
        expect(user1).to receive(:pending_supports_count).and_return(user1.supports.not_done.count)
        expect(user1.has_pending_supports?).to eq(true)
      end
    end

    context 'has no pending supports' do
      it 'returns false' do
        expect(user2).to receive(:pending_supports_count).and_return(user2.supports.not_done.count)
        expect(user2.has_pending_supports?).to eq(false)
      end
    end
  end

end
