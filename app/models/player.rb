class Player < ApplicationRecord
  belongs_to :team
  has_many :player_matches, dependent: :destroy
  has_many :matches, through: :player_matches

  validates :name, presence: true
end
