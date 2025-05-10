FactoryBot.define do
  factory :league_statistic do
    league { association :league }
    team { association :team, league: league }
    matches_played { 0 }
    matches_won { 0 }
    matches_lost { 0 }
    games_won { 0 }
    games_lost { 0 }
    points { 0 }
    rank { nil }

    trait :with_stats do
      matches_played { 5 }
      matches_won { 3 }
      matches_lost { 2 }
      games_won { 63 }
      games_lost { 42 }
      points { 6 }
      rank { 1 }
    end
  end
end
