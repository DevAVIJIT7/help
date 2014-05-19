class Support < ActiveRecord::Base

  has_many :comments, dependent: :destroy
  belongs_to :receiver, class_name: 'User'
  belongs_to :user
  belongs_to :topic, counter_cache: true

  scope :done, -> { where(done: true) }
  scope :not_done, -> { where(done: false) }
  default_scope -> { order(updated_at: :desc) }

  scope :filter_by_topic, -> (topic) { joins(:topic).where(topics: {title: topic} ) }
  scope :filter_by_problem, -> (problem) { where(body: problem) }
  scope :filter_by_receiver, -> (receiver) { joins(:receiver).where("first_name = ? OR last_name = ?", receiver, receiver ) }
  scope :filter_by_user, -> (user) { joins(:user).where("first_name = ? OR last_name = ?", user, user ) }

  def discussed?
    comments_count > 0
  end

  def comments_count
    # TODO: replace with counter cache
    comments.count
  end
end
