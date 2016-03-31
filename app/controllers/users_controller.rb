class UsersController < ApplicationController
  include BCrypt
  # GET /users
  def index
    @users = User.all
  end

  def show
    @tweet = current_user.tweets.build if user_signed_in?
    @feed_items = User.find_by!(slug: params[:id]).tweets.paginate(page: params[:page])
  end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
