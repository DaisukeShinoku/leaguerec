require "rails_helper"

RSpec.describe Match, type: :model do
  describe "バリデーション" do
    let(:pairing) { create(:pairing) }

    context "試合が完了している場合" do
      subject { build(:match, pairing: pairing, completed: true, home_score: nil, away_score: nil) }

      it "スコアが必須" do
        expect(subject).not_to be_valid
        expect(subject.errors[:base]).to include("試合が完了している場合はスコアを入力する必要があります")
      end
    end

    context "試合が完了していない場合" do
      subject { build(:match, pairing: pairing, completed: false, home_score: nil, away_score: nil) }

      it "スコアは必須ではない" do
        expect(subject).to be_valid
      end
    end
  end

  describe "#winner" do
    let(:pairing) { create(:pairing) }
    let(:home_team) { pairing.home_team }
    let(:away_team) { pairing.away_team }

    context "試合が完了していない場合" do
      subject { create(:match, pairing: pairing, completed: false, home_score: 21, away_score: 15) }

      it "nilを返す" do
        expect(subject.winner).to be_nil
      end
    end

    context "ホームチームが勝利した場合" do
      subject { create(:match, pairing: pairing, completed: true, home_score: 21, away_score: 15) }

      it "ホームチームを返す" do
        expect(subject.winner).to eq home_team
      end
    end

    context "アウェイチームが勝利した場合" do
      subject { create(:match, pairing: pairing, completed: true, home_score: 15, away_score: 21) }

      it "アウェイチームを返す" do
        expect(subject.winner).to eq away_team
      end
    end

    context "引き分けの場合" do
      subject { create(:match, pairing: pairing, completed: true, home_score: 21, away_score: 21) }

      it "nilを返す" do
        expect(subject.winner).to be_nil
      end
    end
  end

  describe "#loser" do
    let(:pairing) { create(:pairing) }
    let(:home_team) { pairing.home_team }
    let(:away_team) { pairing.away_team }

    context "試合が完了していない場合" do
      subject { create(:match, pairing: pairing, completed: false, home_score: 21, away_score: 15) }

      it "nilを返す" do
        expect(subject.loser).to be_nil
      end
    end

    context "ホームチームが敗北した場合" do
      subject { create(:match, pairing: pairing, completed: true, home_score: 15, away_score: 21) }

      it "ホームチームを返す" do
        expect(subject.loser).to eq home_team
      end
    end

    context "アウェイチームが敗北した場合" do
      subject { create(:match, pairing: pairing, completed: true, home_score: 21, away_score: 15) }

      it "アウェイチームを返す" do
        expect(subject.loser).to eq away_team
      end
    end

    context "引き分けの場合" do
      subject { create(:match, pairing: pairing, completed: true, home_score: 21, away_score: 21) }

      it "nilを返す" do
        expect(subject.loser).to be_nil
      end
    end
  end

  describe "correct_number_of_players バリデーション" do
    let(:league) { create(:league) }
    let(:home_team) { create(:team, :with_players, league: league) }
    let(:away_team) { create(:team, :with_players, league: league) }
    let(:pairing) { create(:pairing, league: league, home_team: home_team, away_team: away_team) }

    context "シングルス試合" do
      let(:match) { create(:match, pairing: pairing, match_type: :singles) }

      before do
        match.player_matches.build(player: home_team.players.first, team_side: :home)
        match.player_matches.build(player: away_team.players.first, team_side: :away)
        match.player_matches.load
      end

      it "各チーム1人までの選手が有効" do
        expect(match).to be_valid
      end

      it "ホームチームの選手が多すぎる場合は無効" do
        match.player_matches.build(player: home_team.players.second, team_side: :home)
        expect(match).not_to be_valid
        expect(match.errors[:base]).to include("ホームチームの選手が多すぎます")
      end
    end

    context "ダブルス試合" do
      let(:match) { create(:match, pairing: pairing, match_type: :doubles) }

      before do
        match.player_matches.build(player: home_team.players.first, team_side: :home)
        match.player_matches.build(player: home_team.players.second, team_side: :home)
        match.player_matches.build(player: away_team.players.first, team_side: :away)
        match.player_matches.build(player: away_team.players.second, team_side: :away)
        match.player_matches.load
      end

      it "各チーム2人までの選手が有効" do
        expect(match).to be_valid
      end

      it "アウェイチームの選手が多すぎる場合は無効" do
        match.player_matches.build(player: away_team.players.third, team_side: :away)
        expect(match).not_to be_valid
        expect(match.errors[:base]).to include("アウェイチームの選手が多すぎます")
      end
    end
  end
end
