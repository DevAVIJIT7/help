class UsersController < ApplicationController
  expose_decorated(:users) { User.order(supports_count: :desc) }
  expose_decorated(:user) { User.find params[:id] }
  expose_decorated(:supports) { user.supports.done }
  expose_decorated(:skills) { user.skills.includes(:topic) }
end
