class UsersController < ApplicationController
  before_action :set_user, only: [:show, :following, :followers]
  before_action :authenticate_user!

  def index
  end

  def show
  end

  def following
    @title = "Following"
    @users = @user.followed_users
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @users = @user.followers
    render 'show_follow'
  end

  def search
    if params[:search].blank?  
      redirect_to(root_path, alert: "You can't search with the empty field.") and return  
    else
      @parameter = params[:search].downcase

      if @parameter[0] == "@"
        @parameter = @parameter[1...-1]
      end

      @resultsUser = User.all.where("lower(name) LIKE :search OR lower(username) LIKE :search", search: "%#{@parameter}%")
      @resultsTweet = Tweet.all.where("lower(body) LIKE :search", search: "%#{@parameter}%")
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
      @tweets = @user.get_profile_feed
    end
end