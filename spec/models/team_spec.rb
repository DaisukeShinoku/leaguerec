require "rails_helper"

RSpec.describe Team, type: :model do
  describe "#pairings" do
    let(:league) { create(:league) }
    let(:team) { create(:team, league: league) }
    let(:opponent_team) { create(:team, league: league) }
    let(:third_team) { create(:team, league: league) }

    let(:home_pairing) { create(:pairing, league: league, home_team: team, away_team: opponent_team) }
    let(:away_pairing) { create(:pairing, league: league, home_team: third_team, away_team: team) }
    let(:other_pairing) { create(:pairing, league: league, home_team: opponent_team, away_team: third_team) }

    before do
      # 明示的に作成
      home_pairing
      away_pairing
      other_pairing
    end

    it "ホームチームまたはアウェイチームとして参加している対戦カードを返す" do
      pairings = team.pairings

      expect(pairings).to include(home_pairing)
      expect(pairings).to include(away_pairing)
      expect(pairings).not_to include(other_pairing)
    end
  end

  describe "#statistic" do
    let(:league) { create(:league) }
    let(:team) { create(:team, league: league) }

    context "統計情報が存在する場合" do
      let(:statistic) { create(:league_statistic, league: league, team: team) }

      before do
        statistic # 明示的に作成
      end

      it "既存の統計情報を返す" do
        expect(team.statistic).to eq statistic
      end
    end

    context "統計情報が存在しない場合" do
      it "新しい統計情報を構築する" do
        statistic = team.statistic

        expect(statistic).to be_a_new(LeagueStatistic)
        expect(statistic.league).to eq league
        expect(statistic.team).to eq team
      end
    end
  end
end
