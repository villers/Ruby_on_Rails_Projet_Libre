class UsersController < ApplicationController
  # GET /users
  def index
    @users = User.all
  end

  def show
    @tweet = current_user.tweets.build if user_signed_in?
    @feed_items = User.find_by!(slug: params[:id]).tweets.paginate(page: params[:page])
  end
end
