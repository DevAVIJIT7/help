class SupportSearch < Searchlight::Search

  search_on Support.all

  searches :body, :topic_id, :receiver_id, :user_id, :state

  def search_state
    case state
    when 'done'
      search.where(done: true)
    when 'notdone'
      search.where(done: false)
    else
      search.all
    end
  end

  def search_body
    search.where('body ILIKE ?', "%#{body}%")
  end

  def search_topic_id
    search.where(topic_id: topic_id)
  end

  def search_receiver_id
    search.where(receiver_id: receiver_id)
  end

  def search_user_id
    search.where(user_id: user_id)
  end
end
