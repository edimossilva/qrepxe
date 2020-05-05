FactoryBot.define do
  factory :answer do
    to_create do |instance|
      AnswerCollection.save(instance.as_json)
    end

    grade { Faker::Number.between(from: 0, to: 10) }
    company { Faker::Book.publisher }
    timestamp do
      april1 = Time.zone.local(2020, 4, 1)
      april30 = Time.zone.local(2020, 4, 30)
      Faker::Time.between_dates(from: april1, to: april30, period: :all)
    end
  end
end
