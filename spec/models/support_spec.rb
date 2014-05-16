require 'spec_helper'

describe Support do
  subject {  described_class.new }

  let!(:support1) { Support.create }
  let!(:comment) { Comment.create(support_id: support1.id) }

  describe '#discussed?' do
    context 'returns true' do
      after :each do
        expect(subject.discussed?).to be true
      end

      it 'when there are some comments' do
        expect(subject).to receive(:comments_count).and_return(10)
      end

    end
    context 'returns false' do
      after :each do
        expect(subject.discussed?).to be false
      end

      it 'when there are no comments' do
        expect(subject).to receive(:comments_count).and_return(0)
      end
    end
  end

  describe '#comments_count' do
    context 'has comments' do
      it 'returns number other than 0' do
        expect(support1.comments_count).to eq(support1.comments.count)
      end
    end

    context 'has no comments' do
      it 'returns 0' do
        expect(subject.comments_count).to eq(0)
      end
    end
  end
end
