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

  def self.sort_weekly
    all.sort_by{ |s| s.week_supports_count }.reverse.take(7)
  end

  def week_supports_count
    x = 0
    supports.each do |s|
      if s.updated_at < Time.now && s.updated_at > 1.week.ago(Time.now)
        x += 1
      end
    end
    return x
  end

end
