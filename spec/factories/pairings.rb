FactoryBot.define do
  factory :pairing do
    league { association :league }

    transient do
      teams_count { 2 }
    end

    after(:build) do |pairing, evaluator|
      if pairing.home_team.nil? || pairing.away_team.nil?
        teams = create_list(:team, evaluator.teams_count, league: pairing.league)
        pairing.home_team = teams[0]
        pairing.away_team = teams[1]
      end
    end

    trait :with_matches do
      after(:create) do |pairing|
        create(:match, pairing: pairing, match_number: 1)
      end
    end
  end
end
