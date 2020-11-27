require 'rails_helper'

RSpec.describe UsersController, "#following" do
  context "When a user wants to see the followers' or following's list" do
    context "When user is logged in" do
        let(:user) { create(:user) }
        let(:other_user) { create(:user) }

        before do
            sign_in(user)
            user.follow!(other_user)
        end

        context "followed users" do
            before do
                { :get => following_user_path(user) }
            end

            it "Should get the following page with 200 OK code and followed users assigned" do
                expect(assigns(@users)).not_to be_nil
                expect(response).to have_http_status(200)
            end
        end

        context "followers" do
            before do
                { :get => followers_user_path(user) }
            end

            it "Should get the followers page with 200 OK code and followed users assigned" do
                expect(assigns(@users)).not_to be_nil
                expect(response).to have_http_status(200)
            end
        end
    end

    context "When user is NOT logged in" do
        let(:user) { create(:user) }

        context "followed users" do
            before do
                { :get => following_user_path(user) }
            end

            it "Should redirect to sign in" do
                redirect_to new_user_session_path
            end
        end

        context "followers" do
            before do
                { :get => following_user_path(user) }
            end

            it "Should redirect to sign in" do
                redirect_to new_user_session_path
            end
        end
    end
  end
end