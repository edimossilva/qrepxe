FactoryBot.define do
  factory :answer do
    to_create do |instance|
      AnswerCollection.save(instance.as_json)
    end

    grade { Faker::Number.between(from: 0, to: 10) }
    company { Faker::Book.publisher }
    timestamp do
      january1 = Time.zone.local(2020, 1, 1)
      april30 = Time.zone.local(2020, 4, 30)
      Faker::Time.between_dates(from: january1, to: april30, period: :all)
    end

    trait :promoter do
      grade { Faker::Number.between(from: 9, to: 10) }
    end

    trait :passive do
      grade { Faker::Number.between(from: 7, to: 8) }
    end

    trait :detractor do
      grade { Faker::Number.between(from: 0, to: 6) }
    end
  end
end
