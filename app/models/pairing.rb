class Pairing < ApplicationRecord
  belongs_to :league
  belongs_to :home_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"
  has_many :matches, dependent: :destroy

  validates :home_team_id, uniqueness: { scope: %i[league_id away_team_id] }
  validate :teams_must_be_different
  validate :teams_must_belong_to_league

  private

  def teams_must_be_different
    return unless home_team_id == away_team_id

    errors.add(:base, "ホームチームとアウェイチームは異なるチームである必要があります")
  end

  def teams_must_belong_to_league
    return unless league_id.present? && home_team_id.present? && away_team_id.present?
    return if home_team.league_id == league_id && away_team.league_id == league_id

    errors.add(:base, "両チームは同じリーグに所属している必要があります")
  end
end
