class Tweet < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  has_many :likes, dependent: :destroy
  has_many :retweets, dependent: :destroy
  
  validates :body, presence: true, length: {minimum: 1, maximum: 280}   

  # Tweets para el feed
  def self.from_users_followed_by(user)
    # ids de los usuarios que sigue
    followed_user_ids = "SELECT followed_id FROM follows WHERE follower_id = #{user.id}"

    # Tweets propios y tweets de los usuarios que sigue
    tweets_self_followed = "
      SELECT t.id, t.user_id, t.body, t.created_at, t.quoted_tweet_id
      FROM tweets AS t
      WHERE user_id = #{user.id}
      OR user_id IN (#{followed_user_ids}
    "
    
    # Retweets propios y retweets de los usuarios que sigue
    # Se escoge el created_at del retweet (rt.created_at) y no el del tweet
    retweets_self_followed = "
      SELECT t.id, t.user_id, t.body, rt.created_at, t.quoted_tweet_id
      FROM tweets AS t
      INNER JOIN retweets AS rt
      ON rt.tweet_id = t.id
      WHERE rt.user_id = #{user.id} OR rt.user_id IN (#{followed_user_ids})) a
    "

    sql_statement = "SELECT * FROM (#{tweets_self_followed}) UNION #{retweets_self_followed} ORDER BY created_at DESC"

    Tweet.find_by_sql(sql_statement)
  end

  def self.get_profile_feed(user)
    # Tweets propios
    tweets_self = "
      SELECT t.id, t.user_id, t.body, t.created_at, t.quoted_tweet_id
      FROM tweets AS t
      WHERE user_id = #{user.id}
    "

    # Retweets propios
    retweets_self = "
      SELECT t.id, t.user_id, t.body, rt.created_at, t.quoted_tweet_id
      FROM tweets AS t
      INNER JOIN retweets as rt
      ON rt.tweet_id = t.id
      WHERE rt.user_id = #{user.id}
    "
    
    sql_statement = "SELECT * FROM (#{tweets_self}) UNION #{retweets_self} ORDER BY created_at DESC"

    Tweet.find_by_sql(sql_statement)
  end
end
