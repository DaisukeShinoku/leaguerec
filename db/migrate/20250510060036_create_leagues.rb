class CreateLeagues < ActiveRecord::Migration[8.0]
  def change
    create_table :leagues do |t|
      t.string :title, null: false
      t.integer :team_count, null: false
      t.integer :match_per_pairing, null: false

      t.timestamps
    end
  end
end
