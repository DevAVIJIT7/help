class SupportsController < ApplicationController

  expose_decorated(:topic) { Topic.find(params[:topic_id]) }
  expose_decorated(:support) { Support.find(params[:id]) }
  expose_decorated(:comments) { support.comments.includes(:user).order('created_at ASC') }
  expose_decorated(:supports) { filtered_supports.paginate(page: params[:page], per_page: 20) }

  expose(:filtered_supports)   { prefilter }
  expose(:search_params) { params[:query] }

  def prefilter
    supports = Support.all
    if search_params
      case search_params[:search_done]
      when 'done'
        supports = Support.done
      when 'notdone'
        supports = Support.not_done
      else
        supports = Support.all
      end
      if search_params[:search_topic]!= ""
        supports = supports.filter_by_topic(search_params[:search_topic])
      end
      if search_params[:search_problem]!=""
        supports = supports.filter_by_problem(search_params[:search_problem])
      end
      if search_params[:search_receiver]!=""
        supports = supports.filter_by_receiver(search_params[:search_receiver])
      end
      if search_params[:search_user]!=""
        supports = supports.filter_by_user(search_params[:search_user])
      end
    end
    return supports
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

  def support_params
    params.fetch(:support, {}).permit(:body, :user_id)
  end
end
