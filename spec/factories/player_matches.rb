FactoryBot.define do
  factory :player_match do
    player { nil }
    match { nil }
    team_side { 0 }

    trait :home do
      team_side { 0 }

      after(:build) do |player_match|
        if player_match.player.nil? && player_match.match.present?
          player_match.player = create(:player, team: player_match.match.pairing.home_team)
        end
      end
    end

    trait :away do
      team_side { 1 }

      after(:build) do |player_match|
        if player_match.player.nil? && player_match.match.present?
          player_match.player = create(:player, team: player_match.match.pairing.away_team)
        end
      end
    end
  end
end
