class Team < ApplicationRecord
  belongs_to :league
  has_many :players, dependent: :destroy
  has_many :home_pairings, class_name: "Pairing", foreign_key: "home_team_id", dependent: :destroy, inverse_of: :home_team
  has_many :away_pairings, class_name: "Pairing", foreign_key: "away_team_id", dependent: :destroy, inverse_of: :away_team
  has_one :league_statistic, dependent: :destroy

  validates :name, presence: true

  def pairings
    Pairing.where("home_team_id = ? OR away_team_id = ?", id, id)
  end

  def statistic
    league_statistic || build_league_statistic(league: league)
  end
end
