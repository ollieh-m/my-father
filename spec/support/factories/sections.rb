FactoryBot.define do
  factory :section do
    title { Faker::Book.title }
    part
  end
end
