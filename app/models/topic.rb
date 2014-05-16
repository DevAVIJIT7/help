class Topic < ActiveRecord::Base

  has_many :users, through: :skills
  has_many :skills

  validates :title, presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 6 }

  default_scope -> { order(:id) }

  def to_s
    title
  end

  def users_count
    skills_count
  end

end
