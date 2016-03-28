class TweetsController < ApplicationController
  # GET /tweets
  def index
    @users = Tweet.all
  end
end
