class User < ActiveRecord::Base

  has_many :skills
  has_many :topics, through: :skills
  has_many :supports
  has_many :received_supports, as: :receiver
  has_many :comments

  def name
    "#{first_name} #{last_name}".strip
  end

  def to_s
    name
  end

  def has_pending_supports?
    pending_supports_count > 0
  end

  def pending_supports_count
    supports.not_done.count
  end

  def helps_with?(topic)
    @topic_ids ||= skills.pluck(:topic_id)
    @topic_ids.include?(topic.id)
  end

  def self.this_week_best_users
    joins(:supports)
    .where('supports.done = ? AND supports.updated_at >= ?',
      true, Time.now.beginning_of_week)
    .group('users.id')
    .order('count(supports.updated_at) DESC, lower(first_name) ASC')
    .limit(10)
  end
end
