class AddQuotedTweetIdToTweet < ActiveRecord::Migration[6.0]
  def change
    add_column :tweets, :quoted_tweet_id, :integer
  end
end