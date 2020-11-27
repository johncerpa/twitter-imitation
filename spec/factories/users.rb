FactoryBot.define do
  factory :user do
    sequence(:id) { |n| }

    sequence(:email) { |n| "user#{n}@gmail.com" }

    name { "User name" }
    
    sequence(:username) { |n| "user#{n}" }

    sequence(:password) { |n| "password#{n}" }

    created_at { Time.now }
    updated_at { Time.now }
    confirmed_at { Time.now }
  end
end