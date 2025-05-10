class CreateMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :matches do |t|
      t.references :pairing, null: false, foreign_key: true
      t.integer :match_type, null: false, default: 0  # 0: シングルス, 1: ダブルス
      t.integer :match_number, null: false
      t.integer :home_score
      t.integer :away_score
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
