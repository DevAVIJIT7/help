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
    User.connection.select_all <<-SQL.squish
      select users.* from users
      left join supports on users.id = supports.user_id
      where done=true
      group by users.id
      order by count(supports.created_at > '2014-05-15 12:00:00')
    SQL
  end

  def supports_from_beginning_of_week_count
    supports.from_beginning_of_week.count
  end
end
