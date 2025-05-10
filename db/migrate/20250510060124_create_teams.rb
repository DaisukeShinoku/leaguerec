class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.references :league, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
