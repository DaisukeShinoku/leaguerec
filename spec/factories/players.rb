FactoryBot.define do
  factory :player do
    team { association :team }
    sequence(:name) { |n| "プレイヤー#{n}" }
  end
end
