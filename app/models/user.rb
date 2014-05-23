class User < ActiveRecord::Base

  has_many :skills
  has_many :topics, through: :skills
  has_many :supports
  has_many :received_supports, as: :receiver
  has_many :comments

  scope :sorted, -> { order('supports_count DESC, lower(first_name) ASC') }

  def name
    "#{first_name} #{last_name}".strip
  end

  def to_s
    name
  end

  def has_pending_supports?
    supports.not_done.any?
  end

  def pending_supports_count
    supports.not_done.count
  end

  def helps_with?(topic)
    skills.where(topic_id: topic.id).any?
  end

  def self.this_week_best_users
    joins(:supports)
      .where(supports: { done: true })
      .where('supports.updated_at >= ?', Time.zone.now.beginning_of_week)
      .group('users.id')
      .order('count(supports.updated_at) DESC, lower(first_name) ASC')
      .limit(10)
  end
end
