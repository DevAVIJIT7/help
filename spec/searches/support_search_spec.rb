require 'spec_helper'

describe SupportSearch do
  subject { described_class.new }

  describe '#search_body' do
    context 'body is present' do
      it 'searches through body field' do
        expect(subject.search_body).to match_array(subject.search.where('body ILIKE ?', "%test%"))
      end
    end
  end

  describe '#search_topic_id' do
    context 'topic_id is present' do
      it 'searches through topic_id' do
        expect(subject.search_topic_id).to match_array(subject.search.where(topic_id: 1))
      end
    end
  end

  describe '#search_receiver_id' do
    context 'receiver_id is present' do
      it 'searches through receiver_id' do
        expect(subject.search_receiver_id).to match_array(subject.search.where(receiver_id: 1))
      end
    end
  end

  describe '#search_user_id' do
    context 'user_id is present' do
      it 'searches through user_id' do
        expect(subject.search_user_id).to match_array(subject.search.where(user_id: 1))
      end
    end
  end

  describe '#search_state' do
    context 'state is done' do
      it 'chooses only done supports' do
        subject.state = 'done'
        expect(subject.search_state).to match_array(subject.search.done)
      end
    end

    context 'state is not done' do
      it 'chooses only not done supports' do
        subject.state = 'notdone'
        expect(subject.search_state).to match_array(subject.search.not_done)
      end
    end

    context 'state is all' do
      it 'chooses all supports' do
        subject.state = 'all'
        expect(subject.search_state).to eq(subject.search)
      end
    end
  end

  describe '#paginated_results(page_number)' do
    context 'paginate' do
      it 'paginates searched supports' do
        expect(subject.paginated_results(1)).to eq(subject.results.paginate page: 1, per_page: 20)
      end
    end
  end
end
