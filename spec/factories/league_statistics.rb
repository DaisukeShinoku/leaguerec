FactoryBot.define do
  factory :league_statistic do
    league { nil }
    team { nil }
    matches_played { 1 }
    matches_won { 1 }
    matches_lost { 1 }
    games_won { 1 }
    games_lost { 1 }
    points { 1 }
    rank { 1 }
  end
end
