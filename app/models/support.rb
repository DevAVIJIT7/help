class Support < ActiveRecord::Base

  has_many :comments, dependent: :destroy
  belongs_to :receiver, class_name: 'User'
  belongs_to :user
  belongs_to :topic, counter_cache: true

  scope :done, -> { where(done: true) }
  scope :not_done, -> { where(done: false) }
  default_scope -> { order(created_at: :desc) }
  scope :from_beginning_of_week, -> {
    where(arel_table[:updated_at].gt(Time.now.beginning_of_week).
    and(arel_table[:done].eq(true))) }

  def discussed?
    comments_count > 0
  end

  def comments_count
    # TODO: replace with counter cache
    comments.count
  end
end
