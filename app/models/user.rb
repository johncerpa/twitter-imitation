class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, 
         :rememberable, :validatable, :confirmable

  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
  validates :username, uniqueness: true, length: {minimum: 1}
  validates :name, length: {minimum: 1}

  has_many :tweets, dependent: :destroy
  
  has_many :follows, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :follows, source: :followed

  has_many :reverse_follows, foreign_key: "followed_id", class_name: "Follow", dependent: :destroy
  has_many :followers, through: :reverse_follows, source: :follower

  has_many :likes, dependent: :destroy

  has_many :retweets, dependent: :destroy

  has_many :sent, :class_name => "Message", :foreign_key => "sent_id"
  has_many :received, :class_name => "Message", :foreign_key => "recipient_id"

  def following?(other_user)
    follows.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    follows.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    follows.find_by_followed_id(other_user.id).destroy
  end

  def feed
    Tweet.from_users_followed_by(self)
  end

  def get_profile_feed  
    Tweet.get_profile_feed(self)
  end

end
