FactoryBot.define do
  factory :team do
    league { association :league }
    sequence(:name) { |n| "チーム#{n}" }

    trait :with_players do
      after(:create) do |team|
        create_list(:player, 3, team: team)
      end
    end
  end
end
