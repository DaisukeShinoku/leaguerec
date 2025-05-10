FactoryBot.define do
  factory :match do
    pairing { association :pairing }
    match_type { 0 } # シングルス
    sequence(:match_number) { |n| n }
    home_score { nil }
    away_score { nil }
    completed { false }

    trait :completed do
      home_score { 21 }
      away_score { 15 }
      completed { true }
    end

    trait :doubles do
      match_type { 1 } # ダブルス
    end

    trait :with_players do
      after(:create) do |match|
        home_player = create(:player, team: match.pairing.home_team)
        away_player = create(:player, team: match.pairing.away_team)
        create(:player_match, match: match, player: home_player, team_side: :home)
        create(:player_match, match: match, player: away_player, team_side: :away)
      end
    end
  end
end
