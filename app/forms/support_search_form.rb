class SupportSearchForm < Reform::Form
  include Reform::Form::ActiveModel
  property :topic_id
  property :body
  property :receiver_id
  property :user_id

  attr_accessor :search_params

  def set_previous_search(params)
    self.search_params = params
    set_fields
  end

  def set_fields
    if @search_params.present?
      @fields.topic_id = search_params[:topic_id]
      @fields.body = search_params[:body]
      @fields.receiver_id = search_params[:receiver_id]
      @fields.user_id = search_params[:user_id]
    end
  end

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

  def state
    search_params.present? ? search_params[:state] : 'all'
  end
end
