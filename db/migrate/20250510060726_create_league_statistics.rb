class CreateLeagueStatistics < ActiveRecord::Migration[8.0]
  def change
    create_table :league_statistics do |t|
      t.references :league, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.integer :matches_played, default: 0
      t.integer :matches_won, default: 0
      t.integer :matches_lost, default: 0
      t.integer :games_won, default: 0
      t.integer :games_lost, default: 0
      t.integer :points, default: 0
      t.integer :rank

      t.timestamps
    end
    
    add_index :league_statistics, [:league_id, :team_id], unique: true
  end
end
