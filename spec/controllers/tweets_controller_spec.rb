require 'rails_helper'

RSpec.describe TweetsController, "#create" do
  context "When a tweet is created with invalid fields" do
    it "Should raise a RecordInvalid error" do
      expect {
        Tweet.create!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context "When user is logged in" do
    let(:user) { create(:user) }

    before do
      sign_in(user)
      post :create, params: {
        tweet: {user_id: user.id, body: "New test tweet"}
      }
    end

    it "Should create a new tweet" do
      expect(Tweet.last.body).to eq("New test tweet")
    end

    it "Should redirect to tweets index" do
      expect(subject).to redirect_to tweets_path
    end
  end

  context "When user is NOT logged in" do
    let(:user) { create(:user) }

    before do
      post :create, params: {
        tweet: {user_id: user.id, body: "New test tweet"}
      }
    end

    it "Should redirect to sign in page" do
      expect(subject).to redirect_to new_user_session_path
    end
  end
end

RSpec.describe TweetsController, "#destroy" do
  context "When user is logged in" do
    let(:user) {
      create(:user)
    }

    let(:tweet) {
      create(:tweet, user_id: user.id)
    }

    before do
      sign_in(user)

      delete :destroy, params: { id: tweet.id }
    end

    it "Should delete that tweet and leave the table empty" do
      expect(Tweet.all).to be_empty
    end

    it "Should redirect to tweets index" do
      expect(subject).to redirect_to tweets_path
    end
  end

  context "When user is NOT logged in" do
    let(:user) { create(:user) }

    let(:tweet) {
      create(:tweet, user_id: user.id)
    }

    before do
      delete :destroy, params: { id: tweet.id }
    end

    it "Should NOT delete that tweet and the table should not be empty" do
      expect(Tweet.all).not_to be_empty
    end

    it "Should redirect to sign in page" do
      expect(subject).to redirect_to new_user_session_path
    end
  end
end

RSpec.describe TweetsController, "#index" do
  context "When user is logged in" do
    let(:user) { create(:user) }

    before do
      sign_in(user)
    end

    it "Should get tweets index page with 200 OK code and tweets assigned" do
      get("index")

      expect(assigns(:tweets)).not_to be_nil
      expect(response).to have_http_status(200)
    end
  end

  context "When user is NOT logged in" do
    it "Should get a 302 code and redirect to sign in" do
      get("index")
      
      expect(assigns(:tweets)).to be_nil
      expect(response).to have_http_status(302)
      expect(subject).to redirect_to new_user_session_path
    end
  end
end


