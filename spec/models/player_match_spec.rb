require "rails_helper"

RSpec.describe PlayerMatch, type: :model do
  describe "バリデーション" do
    # 共通のセットアップ
    let(:league) { create(:league) }
    let(:home_team) { create(:team, league: league) }
    let(:away_team) { create(:team, league: league) }
    let(:pairing) { create(:pairing, league: league, home_team: home_team, away_team: away_team) }
    let(:match) { create(:match, pairing: pairing) }

    context "選手がホームチームに所属している場合" do
      subject { build(:player_match, match: match, player: home_player, team_side: :home) }

      # このコンテキスト固有のセットアップ
      let(:home_player) { create(:player, team: home_team) }

      it "有効である" do
        expect(subject).to be_valid
      end
    end

    context "選手がアウェイチームに所属している場合" do
      subject { build(:player_match, match: match, player: away_player, team_side: :away) }

      # このコンテキスト固有のセットアップ
      let(:away_player) { create(:player, team: away_team) }

      it "有効である" do
        expect(subject).to be_valid
      end
    end

    context "選手がホームチームに所属しているがアウェイ側で登録された場合" do
      subject { build(:player_match, match: match, player: home_player, team_side: :away) }

      # このコンテキスト固有のセットアップ
      let(:home_player) { create(:player, team: home_team) }

      it "無効である" do
        expect(subject).not_to be_valid
        expect(subject.errors[:player]).to include("はアウェイチームに所属している必要があります")
      end
    end

    context "選手がアウェイチームに所属しているがホーム側で登録された場合" do
      subject { build(:player_match, match: match, player: away_player, team_side: :home) }

      # このコンテキスト固有のセットアップ
      let(:away_player) { create(:player, team: away_team) }

      it "無効である" do
        expect(subject).not_to be_valid
        expect(subject.errors[:player]).to include("はホームチームに所属している必要があります")
      end
    end
  end
end
