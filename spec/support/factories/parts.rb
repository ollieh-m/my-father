FactoryBot.define do
  factory :part do
    title { Faker::Book.title }
  end
end
