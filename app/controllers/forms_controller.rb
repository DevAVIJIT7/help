class FormsController < ApplicationController

  class SearchForm < ActiveModel::Form
    self.model_name = 'search'
    attribute :state, :string
    attribute :topic_id, :integer
    attribute :body, :string
    attribute :receiver_id, :integer
    attribute :user_id, :integer

    def users
      User.decorate
    end

    def topics
      Topic.decorate
    end

    def states
      [
        ['All', :all],
        ['Done', :done],
        ['Not done', :notdone]
      ]
    end

    def get_state
      state.present? ? state : 'all'
    end
  end
end
