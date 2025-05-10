require "rails_helper"

RSpec.describe LeagueStatistic, type: :model do
  describe "#win_rate" do
    context "試合が行われている場合" do
      subject { build(:league_statistic, matches_played: 5, matches_won: 3) }

      it "勝率を計算する" do
        expect(subject.win_rate).to eq 0.6
      end
    end

    context "試合が行われていない場合" do
      subject { build(:league_statistic, matches_played: 0, matches_won: 0) }

      it "0を返す" do
        expect(subject.win_rate).to eq 0.0
      end
    end
  end

  describe "#game_win_rate" do
    context "ゲームが行われている場合" do
      subject { build(:league_statistic, games_won: 60, games_lost: 40) }

      it "ゲーム取得率を計算する" do
        expect(subject.game_win_rate).to eq 0.6
      end
    end

    context "ゲームが行われていない場合" do
      subject { build(:league_statistic, games_won: 0, games_lost: 0) }

      it "0を返す" do
        expect(subject.game_win_rate).to eq 0.0
      end
    end
  end

  describe "#recalculate!" do
    let(:league) { create(:league) }
    let(:team) { create(:team, league: league) }
    let(:other_team) { create(:team, league: league) }
    let(:statistic) { create(:league_statistic, league: league, team: team) }

    context "試合結果がある場合" do
      before do
        pairing = create(:pairing, league: league, home_team: team, away_team: other_team)

        # チームが勝った試合
        create(:match, :completed, pairing: pairing, home_score: 21, away_score: 15)

        # チームが負けた試合
        create(:match, :completed, pairing: pairing, home_score: 15, away_score: 21)

        # 引き分けの試合
        create(:match, :completed, pairing: pairing, home_score: 21, away_score: 21)

        # 未完了の試合
        create(:match, pairing: pairing, home_score: nil, away_score: nil, completed: false)
      end

      it "統計情報を正しく再計算する" do
        statistic.recalculate!

        expect(statistic.matches_played).to eq 3  # 完了した試合のみカウント
        expect(statistic.matches_won).to eq 1     # 勝利した試合
        expect(statistic.matches_lost).to eq 1    # 敗北した試合
        expect(statistic.games_won).to eq 57      # 21 + 15 + 21
        expect(statistic.games_lost).to eq 57     # 15 + 21 + 21
        expect(statistic.points).to eq 3          # 勝ち1回(2点) + 引き分け1回(1点)
      end
    end

    context "試合結果がない場合" do
      it "全ての値が0になる" do
        statistic.recalculate!

        expect(statistic.matches_played).to eq 0
        expect(statistic.matches_won).to eq 0
        expect(statistic.matches_lost).to eq 0
        expect(statistic.games_won).to eq 0
        expect(statistic.games_lost).to eq 0
        expect(statistic.points).to eq 0
      end
    end
  end
end
