class Support < ActiveRecord::Base

  has_many :comments, dependent: :destroy
  belongs_to :receiver, class_name: 'User'
  belongs_to :user
  belongs_to :topic, counter_cache: true

  scope :done, -> { where(done: true) }
  scope :not_done, -> { where(done: false) }
  default_scope -> { order(updated_at: :desc) }

  scope :filter_by_topic, -> (topic) { joins(:topic).where(Topic.arel_table[:title].matches("%#{topic}%") ) }
  scope :filter_by_problem, -> (problem) { where(Support.arel_table[:body].matches("%#{problem}%")) }
  scope :filter_by_receiver, -> (receiver) { joins(:receiver).where(User.arel_table[:first_name].matches("%#{receiver}%").
      or(User.arel_table[:last_name].matches("%#{receiver}%"))) }
  scope :filter_by_user, -> (user) { joins(:user).where(User.arel_table[:first_name].matches("%#{user}%").
      or(User.arel_table[:last_name].matches("%#{user}%"))) }

  def discussed?
    comments_count > 0
  end

  def comments_count
    # TODO: replace with counter cache
    comments.count
  end
end
