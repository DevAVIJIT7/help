class UserDecorator < Draper::Decorator

  decorates :user

  delegate :email, :id, :supports_count, :pending_supports_count, :archived?

  def topic_class(topic)
    'active' if object.helps_with?(topic.object)
  end

  def help_summary(topic)
    object.helps_with?(topic.object) ? "you can help with that!" : "you are not helping yet."
  end

  def gravatar(size = 80)
    h.gravatar_image_tag(object.email, size)
  end

  def info
    h.content_tag :span, h.raw(h.link_to(gravatar + to_s, object)), class: 'user-info'
  end

  def to_s
    object.to_s.titleize
  end

  def points_from_beginning_of_week
    object.supports.from_beginning_of_week.count
  end
end
