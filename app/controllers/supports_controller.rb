class SupportsController < ApplicationController

  expose_decorated(:topic)    { Topic.find(params[:topic_id]) }
  expose_decorated(:support)  { Support.find(params[:id]) }
  expose_decorated(:comments) { support.comments.includes(:user).order('created_at ASC') }

  expose_decorated(:supports, decorator: SupportCollectionDecorator) do
    supports_filtered.paginate(page: params[:page], per_page: 20)
  end

  expose(:supports_filtered) { filter_input(filter_state) }
  expose(:search_params)     { params[:query] }

  %i(search_topic search_problem search_receiver search_user search_state).each do |name|
    expose(name) { search_params.present? ? search_params[name] : nil }
  end

  def index
  end

  def create
    need_support = AskForSupport.new(current_user.object, topic, support_params)
    need_support.commence!

    redirect_to root_path, notice: t('support.create.notice',
                                     name: need_support.supporter)
  end

  def skip
    skip_service = SkipSupport.new support
    skip_service.commence!
    if skip_service.success?
      redirect_to support_path(support), notice: t('support.skip.notice')
    else
      # FIXME: doesn't work with `error: ...` syntax (no flash wrapper)
      redirect_to support_path(support), flash: { error: t('support.skip.error') }
    end
  end

  def ack
    acknowledge_support = AcknowledgeSupport.new current_user.object, support
    acknowledge_support.commence!

    redirect_to support_path(support),
      notice: t('support.ack.notice')
  end

  def finish
    support_finish = FinishSupport.new(current_user.object, support)
    support_finish.commence!
    redirect_to root_path, notice: t('support.finish.notice')
  end

  private
  def filter_state
    case search_state
    when 'done'
      Support.done
    when 'notdone'
      Support.not_done
    else
      Support.all
    end
  end

  def filter_input (supports_list)
    return supports_list unless search_params.present?

    if search_topic.present?
      supports_list = supports_list.filter_by_topic(search_topic)
    end
    if search_problem.present?
      supports_list  = supports_list.filter_by_problem(search_problem)
    end
    if search_receiver.present?
      supports_list = supports_list.filter_by_receiver(search_receiver)
    end
    if search_user.present?
      supports_list = supports_list.filter_by_user(search_user)
    end

    supports_list
  end

  def support_params
    params.fetch(:support, {}).permit(:body, :user_id)
  end
end
