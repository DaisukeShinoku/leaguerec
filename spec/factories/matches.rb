FactoryBot.define do
  factory :match do
    pairing { nil }
    match_type { 1 }
    match_number { 1 }
    home_score { 1 }
    away_score { 1 }
    completed { false }
  end
end
