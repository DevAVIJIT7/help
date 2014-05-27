class TopicsController < ApplicationController

  expose(:support) { Support.new support_params }
  expose_decorated(:topics) { Topic.all }
  expose_decorated(:topic) { Topic.find(params[:id]) }
  expose_decorated(:random_supporter, decorator: UserDecorator) {
    topic.users.without(current_user.object).sample
  }

  def index
  end

  private

  def support_params
    params.fetch(:support, {}).permit(:body)
  end
end
