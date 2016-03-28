class TweetsController < ApplicationController
  # GET /tweets
  def index
    @tweet = current_user.tweets.build if signed_in?
    @feed_items = Tweet.all.paginate(page: params[:page])
    render 'static_pages/home'
  end

  def create
    @tweet = current_user.tweets.build(tweet_params)
    if @tweet.save
      flash[:success] = 'Micropost created!'
      redirect_to root_url
    else
      flash[:danger] = @tweet.errors.full_messages.to_sentence
      redirect_to root_url
    end
  end

  private
    def tweet_params
      params.require(:tweet).permit(:content)
    end
end
