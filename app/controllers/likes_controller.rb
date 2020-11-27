class LikesController < ApplicationController
  before_action :find_tweet
  before_action :find_like, only: [:destroy]

  def create
    if been_liked?
      flash[:notice] = "You can't like more than once."
    else
      @tweet.likes.create(user_id: current_user.id)
    end
    redirect_to tweets_path
  end

  def destroy
    if !(been_liked?)
      flash[:notice] = "Cannot unlike."
    else
      @like.destroy
    end
    redirect_to tweets_path
  end

  private
    def find_tweet
      @tweet = Tweet.find(params[:tweet_id])
    end

    def been_liked?
      Like.where(user_id: current_user.id, tweet_id: params[:tweet_id]).exists?
    end
    
    def find_like
      @like = @tweet.likes.find(params[:id])
    end
end
