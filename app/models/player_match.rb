class PlayerMatch < ApplicationRecord
  belongs_to :player
  belongs_to :match

  enum :team_side, { home: 0, away: 1 }

  validates :team_side, presence: true
  validate :player_belongs_to_correct_team

  private

  def player_belongs_to_correct_team
    return unless player && match && team_side

    expected_team = team_side == "home" ? match.pairing.home_team : match.pairing.away_team

    return if player.team_id == expected_team.id

    errors.add(:player, "は#{team_side == 'home' ? 'ホーム' : 'アウェイ'}チームに所属している必要があります")
  end
end
