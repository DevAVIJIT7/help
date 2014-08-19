require 'render_anywhere'

class HipChat::MessageBuilder
  extend RenderAnywhere

  def self.supports_skip_message(support, previous_user)
    hipchat_render(
      'hipchat/supports/skip',
      {
        support: support.decorate,
        user: previous_user.decorate
      }
    )
  end

  def self.supports_finish_message(support)
    hipchat_render(
      'hipchat/supports/finish',
      { support: support.decorate }
    )
  end

  def self.supports_create_message(support)
    hipchat_render(
      'hipchat/supports/create',
      { support: support.decorate }
    )
  end

  private

  def self.hipchat_render(template_path, local_variables = {})
    render(
      template: template_path,
      layout: false,
      locals: local_variables
    ).to_str
  end
end

