require 'spec_helper'

describe SupportSearch do
  describe '#results' do
    def prepare_supports
      @support ||= Support.create!(user_id: 1,
                                   topic_id: 11,
                                   receiver_id: 111,
                                   body: 'foo bar baz')
      @done_support ||= Support.create!(user_id: 2,
                                        topic_id: 22,
                                        receiver_id: 222,
                                        body: 'bingo mingo mongo',
                                        done: true)
    end

    before :all do
      prepare_supports
    end

    describe 'filters supports by' do
      let!(:support) { @support }
      let!(:done_support) { @done_support }

      it 'user_id' do
        search_attrs = { user_id: support.user_id }
        expect(SupportSearch.new(search_attrs).results).to eq [support]
      end

      it 'receiver_id' do
        search_attrs = { receiver_id: support.receiver_id }
        expect(SupportSearch.new(search_attrs).results).to eq [support]
      end

      it 'receiver_id' do
        search_attrs = { topic_id: support.topic_id }
        expect(SupportSearch.new(search_attrs).results).to eq [support]
      end

      it 'body' do
        search_attrs = { body: 'bar' }
        expect(SupportSearch.new(search_attrs).results).to eq [support]
      end

      describe "state representing" do
        it 'done supports' do
          search_attrs = { state: 'done' }
          expect(SupportSearch.new(search_attrs).results).to eq [done_support]
        end

        it 'pending supports' do
          search_attrs = { state: 'notdone' }
          expect(SupportSearch.new(search_attrs).results).to eq [support]
        end

        it 'all supports' do
          search_attrs = { state: 'all' }
          expect(SupportSearch.new(search_attrs).results).to match_array(
            [support, done_support]
          )
        end
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
