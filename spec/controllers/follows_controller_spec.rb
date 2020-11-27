require 'rails_helper'

RSpec.describe FollowsController, "#create" do
    context "When a follow is created with invalid fields" do
        it "Should raise a RecordInvalid error" do
            expect {
                Follow.create!
            }.to raise_error(ActiveRecord::RecordInvalid)
        end
    end

    context "When user is logged in" do
        let(:user) { create(:user) }
        let(:other_user) { create(:user) }
    
        before do
          sign_in(user)
          post :create, params: {
            follow: {follower_id: user.id, followed_id: other_user.id}
          }
        end
    
        it "Should create a new follow" do
          expect(Follow.last.followed_id).to eq(other_user.id)
          expect(Follow.last.follower_id).to eq(user.id)
        end
    end

    context "When user is NOT logged in" do
        let(:user) { create(:user) }
        let(:other_user) { create(:user) }

        before { allow(controller).to receive(:current_user) { user } }
    
        before do
          post :create, params: {
            follow: {follower_id: user.id, followed_id: other_user.id}
          }
        end
    
        it "Should redirect to sign in page" do
            expect {
                Follow.create!
              }.to raise_error(ActiveRecord::RecordInvalid)
        end
    end
end