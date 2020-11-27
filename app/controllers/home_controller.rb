class HomeController < ApplicationController
  def index
    if current_user
      redirect_to tweets_path
    end
  end
end
