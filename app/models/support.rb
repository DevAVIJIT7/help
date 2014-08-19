class Support < ActiveRecord::Base

  has_many :comments, dependent: :destroy
  belongs_to :receiver, class_name: 'User'
  belongs_to :user
  belongs_to :topic, counter_cache: true

  default_scope -> { order(updated_at: :desc) }
  scope :done, -> { where(done: true) }
  scope :not_done, -> { where(done: false) }
  scope :from_beginning_of_week, -> do
    done.where('supports.updated_at >= ?', Time.current.beginning_of_week)
  end

  if AppConfig.hipchat.active
    after_create :notify_create
  end

  def discussed?
    comments_count > 0
  end

  def notify_create
    if persisted? && active?
      msg = HipChat::MessageBuilder.supports_create_message(self)
      hipchat_notify(msg)
    end
  end

  def notify_skip previous_user
    if persisted? && active?
      msg = HipChat::MessageBuilder.supports_skip_message(self, previous_user)
      hipchat_notify(msg)
    end
  end

  def notify_finish
    if persisted? && active?
      msg = HipChat::MessageBuilder.supports_finish_message(self)
      hipchat_notify(msg)
    end
  end

  def hipchat_notify(msg)
    HipChat::Notifier.new.send_notification(msg)
  end
end
