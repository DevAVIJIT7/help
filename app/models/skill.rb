class Skill < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  belongs_to :topic, counter_cache: true

  scope :active, -> { joins(:user).where("users.archived = ?", false) }

end
