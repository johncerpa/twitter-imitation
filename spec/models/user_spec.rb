require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'Should validate the presence of email' do
      should validate_presence_of(:email)
    end

    context "When given an invalid email format it should not allow it" do
      it { should_not allow_value("invalid_email.com").for(:email) }
    end

    it 'Should validate the presence and length of password' do
      should validate_presence_of(:password)
      should validate_length_of(:password).is_at_least(6) 
    end

    context "When user tries to register with a name with 0 characters" do
      it  "Should not be valid" do
        expect {
          create(:user, name: "")
        }.to raise_error(ActiveRecord::RecordInvalid)
      end      
    end

    context "When user tries to register with an used username it should raise an error" do
      it "Should raise a RecordInvalid error" do
        expect {
          create_list(:user, 2, username: "sameUsername")
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
 
    context 'When two users try to register with the same email' do
      it 'Should raise a RecordInvalid error' do
        expect {
          create_list(:user, 2, email: "uniqueEmail@gmail.com")
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'Associations' do
    it { should have_many(:tweets) }  
  end
end
