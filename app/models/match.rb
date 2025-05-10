class Match < ApplicationRecord
  belongs_to :pairing
  has_many :player_matches, dependent: :destroy
  has_many :players, through: :player_matches

  enum :match_type, { singles: 0, doubles: 1 }

  validates :match_number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :home_score, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :away_score, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validate :scores_present_if_completed
  validate :correct_number_of_players

  def winner
    return nil unless completed
    return nil if home_score == away_score

    home_score > away_score ? pairing.home_team : pairing.away_team
  end

  def loser
    return nil unless completed
    return nil if home_score == away_score

    home_score < away_score ? pairing.home_team : pairing.away_team
  end

  private

  def scores_present_if_completed
    return unless completed && (home_score.nil? || away_score.nil?)

    errors.add(:base, "試合が完了している場合はスコアを入力する必要があります")
  end

  def correct_number_of_players
    return unless player_matches.loaded?

    home_players = player_matches.count(&:home?)
    away_players = player_matches.count(&:away?)

    expected_players = singles? ? 1 : 2

    errors.add(:base, "ホームチームの選手が多すぎます") if home_players > expected_players

    return unless away_players > expected_players

    errors.add(:base, "アウェイチームの選手が多すぎます")
  end
end
