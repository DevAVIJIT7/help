class SupportSearchForm < Reform::Form
  include Reform::Form::ActiveModel
  property :topic_id
  property :body
  property :receiver_id
  property :user_id

  def users
    User.decorate
  end

  def topics
    Topic.decorate
  end

  def state
    [
      ['All', :all],
      ['Done', :done],
      ['Not done', :notdone]
    ]
  end

  def get_state(params)
    params.present? ? params[:state] : 'all'
  end
end
