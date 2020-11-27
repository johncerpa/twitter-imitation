class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @tweet = Tweet.new
    @tweets = current_user.feed
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = current_user.tweets.new(tweet_params)
    
    if params[:quoted_tweet_id].present?
      @tweet.quoted_tweet_id = params[:quoted_tweet_id]
    end

    if @tweet.save
      redirect_to tweets_path
    else
      @tweets = Tweet.all
      render :index
    end
  end

  def edit
  end

  def update
    if @tweet.update(tweet_params)
      redirect_to tweets_path
    else
      @tweets = Tweet.all
      render :index
    end
  end

  def show
    render tweet_path  
  end

  def destroy
    if current_user == @tweet.user
      @tweet.destroy
    end

    redirect_to tweets_path
  end
 
  private
    def tweet_params
      params.require(:tweet).permit(:body, :photo)
    end

    def set_tweet
      @tweet = Tweet.find(params[:id])
    end
end