require "rails_helper"

RSpec.describe League, type: :model do
  describe "#generate_matches" do
    let(:league) { create(:league, team_count: 3, match_per_pairing: 2) }
    let(:team_a) { create(:team, league: league) }
    let(:team_b) { create(:team, league: league) }
    let(:team_c) { create(:team, league: league) }

    before do
      # テストで明示的に参照されなくても、リーグにチームが必要
      team_a
      team_b
      team_c
    end

    it "チーム同士の対戦カードを作成する" do
      expect { league.generate_matches }.to change(Pairing, :count).by(3) # 3C2 = 3
    end

    it "各対戦に必要な試合数を作成する" do
      expect { league.generate_matches }.to change(Match, :count).by(6) # 3C2 * 2 = 6
    end

    it "作成された試合が正しい対戦カードに紐づいている" do
      league.generate_matches

      pairings = league.pairings
      expect(pairings.count).to eq 3

      pairings.each do |pairing|
        expect(pairing.matches.count).to eq 2
        pairing.matches.each do |match|
          expect(match.match_number).to be_between(1, 2)
        end
      end
    end
  end

  describe "#update_statistics" do
    let(:league) { create(:league) }
    let(:team_a) { create(:team, league: league) }
    let(:team_b) { create(:team, league: league) }
    let(:pairing) { create(:pairing, league: league, home_team: team_a, away_team: team_b) }

    before do
      # 試合を作成して結果を設定
      create(:match, :completed, pairing: pairing, home_score: 21, away_score: 15)
      create(:match, :completed, pairing: pairing, home_score: 15, away_score: 21)
    end

    it "各チームの統計情報を作成する" do
      expect { league.update_statistics }.to change(LeagueStatistic, :count).by(2)
    end

    it "チームAの統計情報を正しく更新する" do
      league.update_statistics
      team_a_stat = team_a.league_statistic

      expect(team_a_stat.matches_played).to eq 2
      expect(team_a_stat.matches_won).to eq 1
      expect(team_a_stat.matches_lost).to eq 1
      expect(team_a_stat.games_won).to eq 36  # 21 + 15
      expect(team_a_stat.games_lost).to eq 36 # 15 + 21
      expect(team_a_stat.points).to eq 2      # 勝ち1回 = 2点
    end

    it "チームBの統計情報を正しく更新する" do
      league.update_statistics
      team_b_stat = team_b.league_statistic

      expect(team_b_stat.matches_played).to eq 2
      expect(team_b_stat.matches_won).to eq 1
      expect(team_b_stat.matches_lost).to eq 1
      expect(team_b_stat.games_won).to eq 36  # 15 + 21
      expect(team_b_stat.games_lost).to eq 36 # 21 + 15
      expect(team_b_stat.points).to eq 2      # 勝ち1回 = 2点
    end
  end

  describe "#calculate_rankings" do
    let(:league) { create(:league) }
    let(:team_a) { create(:team, league: league) }
    let(:team_b) { create(:team, league: league) }
    let(:team_c) { create(:team, league: league) }

    before do
      # チームAの統計: 勝点4, 勝利2, ゲーム取得率0.6
      create(:league_statistic, league: league, team: team_a,
                                matches_played: 3, matches_won: 2, matches_lost: 1,
                                games_won: 60, games_lost: 40, points: 4)

      # チームBの統計: 勝点4, 勝利2, ゲーム取得率0.5
      create(:league_statistic, league: league, team: team_b,
                                matches_played: 3, matches_won: 2, matches_lost: 1,
                                games_won: 50, games_lost: 50, points: 4)

      # チームCの統計: 勝点0, 勝利0, ゲーム取得率0.3
      create(:league_statistic, league: league, team: team_c,
                                matches_played: 2, matches_won: 0, matches_lost: 2,
                                games_won: 30, games_lost: 70, points: 0)
    end

    it "勝ち点 > 勝利数 > ゲーム取得率の順で順位を計算する" do
      league.calculate_rankings

      expect(team_a.league_statistic.reload.rank).to eq 1
      expect(team_b.league_statistic.reload.rank).to eq 2
      expect(team_c.league_statistic.reload.rank).to eq 3
    end
  end
end
