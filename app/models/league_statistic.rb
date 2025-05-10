class LeagueStatistic < ApplicationRecord
  belongs_to :league
  belongs_to :team

  validates :matches_played, :matches_won, :matches_lost, :games_won, :games_lost, :points,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :rank, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :team_id, uniqueness: { scope: :league_id }

  def win_rate
    matches_played.positive? ? (matches_won.to_f / matches_played) : 0.0
  end

  def game_win_rate
    (games_won + games_lost).positive? ? (games_won.to_f / (games_won + games_lost)) : 0.0
  end

  def recalculate!
    matches = Match.joins(pairing: :league)
                   .where(pairings: { league_id: league_id })
                   .where("pairings.home_team_id = ? OR pairings.away_team_id = ?", team_id, team_id)
                   .where(completed: true)

    self.matches_played = matches.count
    self.matches_won = matches.count { |m| m.winner&.id == team_id }
    self.matches_lost = matches.count { |m| m.loser&.id == team_id }

    home_matches = matches.select { |m| m.pairing.home_team_id == team_id }
    away_matches = matches.select { |m| m.pairing.away_team_id == team_id }

    self.games_won = home_matches.sum(&:home_score) + away_matches.sum(&:away_score)
    self.games_lost = home_matches.sum(&:away_score) + away_matches.sum(&:home_score)

    # 勝ち点計算（勝利2点、引き分け1点、敗北0点）
    self.points = (matches_won * 2) + (matches_played - matches_won - matches_lost)

    save
  end
end
