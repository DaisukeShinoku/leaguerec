class League < ApplicationRecord
  has_many :teams, dependent: :destroy
  has_many :pairings, dependent: :destroy
  has_many :league_statistics, dependent: :destroy

  validates :title, presence: true
  validates :team_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 2 }
  validates :match_per_pairing, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  # リーグ戦の全試合を自動生成
  def generate_matches
    # 全チーム同士の対戦カードを作成
    teams.to_a.combination(2).each do |team_a, team_b|
      pairing = pairings.create!(home_team: team_a, away_team: team_b)

      # 各対戦に必要な試合数を作成
      match_per_pairing.times do |i|
        pairing.matches.create!(match_number: i + 1)
      end
    end
  end

  # 全チームの統計情報を更新
  def update_statistics
    teams.each do |team|
      stat = league_statistics.find_or_create_by(team: team)
      stat.recalculate!
    end

    calculate_rankings
  end

  # チームの順位を計算
  def calculate_rankings
    stats = league_statistics.to_a

    # 勝ち点 > 勝利数 > ゲーム取得率の順でソート
    sorted_stats = stats.sort_by do |stat|
      [stat.points, stat.matches_won, stat.game_win_rate]
    end.reverse

    # 順位を設定
    sorted_stats.each_with_index do |stat, index|
      stat.update(rank: index + 1)
    end
  end
end
