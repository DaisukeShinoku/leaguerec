class CreatePairings < ActiveRecord::Migration[8.0]
  def change
    create_table :pairings do |t|
      t.references :league, null: false, foreign_key: true
      t.references :home_team, null: false, foreign_key: { to_table: :teams }
      t.references :away_team, null: false, foreign_key: { to_table: :teams }

      t.timestamps
    end
    
    add_index :pairings, [:home_team_id, :league_id, :away_team_id], unique: true, name: 'index_pairings_on_home_team_league_away_team'
  end
end
