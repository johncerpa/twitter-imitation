require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe 'Validations' do
    it 'Should validate the presence of body' do
      should validate_presence_of(:body)
    end

    it 'Should validate the length of body' do
      should validate_length_of(:body).is_at_least(1).is_at_most(280)
    end
  end

  describe 'Associations' do
    it { should belong_to(:user) }  
  end
end
