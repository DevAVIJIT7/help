class ArchiveUser

  attr_accessor :user

  def initialize user
    self.user = user
  end

  def commence!
    archive
    delete_skills
    user.save!
  end

  def archive
    user.archived = true
  end

  def delete_skills
    user.skills.each do |skill|
      skill.destroy
    end
  end
end
