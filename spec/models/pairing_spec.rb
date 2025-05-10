require "rails_helper"

RSpec.describe Pairing, type: :model do
  describe "バリデーション" do
    let(:league) { create(:league) }
    let(:team_a) { create(:team, league: league) }
    let(:team_b) { create(:team, league: league) }
    let(:other_league) { create(:league) }
    let(:other_team) { create(:team, league: other_league) }

    context "同一リーグ内の異なるチーム同士の対戦" do
      subject { build(:pairing, league: league, home_team: team_a, away_team: team_b) }

      it "有効である" do
        expect(subject).to be_valid
      end
    end

    context "同じチーム同士の対戦" do
      subject { build(:pairing, league: league, home_team: team_a, away_team: team_a) }

      it "無効である" do
        expect(subject).not_to be_valid
        expect(subject.errors[:base]).to include("ホームチームとアウェイチームは異なるチームである必要があります")
      end
    end

    context "異なるリーグのチームとの対戦" do
      subject { build(:pairing, league: league, home_team: team_a, away_team: other_team) }

      it "無効である" do
        expect(subject).not_to be_valid
        expect(subject.errors[:base]).to include("両チームは同じリーグに所属している必要があります")
      end
    end

    context "同じ組み合わせの対戦が既に存在する場合" do
      subject { build(:pairing, league: league, home_team: team_a, away_team: team_b) }

      before { create(:pairing, league: league, home_team: team_a, away_team: team_b) }

      it "無効である" do
        expect(subject).not_to be_valid
        expect(subject.errors[:home_team_id]).to include("はすでに存在します")
      end
    end
  end
end
