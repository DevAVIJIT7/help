class Topic < ActiveRecord::Base

  has_many :users, through: :skills
  has_many :skills

  default_scope -> { order('lower(title)') }

  def to_s
    title
  end

  def users_count
    skills_count
  end

end
