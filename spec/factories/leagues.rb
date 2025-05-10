FactoryBot.define do
  factory :league do
    title { "テストリーグ" }
    team_count { 4 }
    match_per_pairing { 2 }

    trait :with_teams do
      after(:create) do |league|
        create_list(:team, league.team_count, league: league)
      end
    end

    trait :with_matches do
      after(:create) do |league|
        create(:team, :with_players, league: league, name: "チームA")
        create(:team, :with_players, league: league, name: "チームB")
        pairing = create(:pairing, league: league,
                                   home_team: Team.find_by(name: "チームA"),
                                   away_team: Team.find_by(name: "チームB"))
        create(:match, pairing: pairing, match_number: 1)
      end
    end
  end
end
