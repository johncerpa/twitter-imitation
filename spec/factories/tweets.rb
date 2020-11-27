FactoryBot.define do
  factory :tweet do
    sequence(:id) { |n| }

    user_id {}
    body { "Testing the destroy method" }

    created_at { Time.now }
    updated_at { Time.now }
  end
end