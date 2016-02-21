class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.string     :ship_type, null: false
      t.jsonb      :location, null: false

      t.references :game, null: false
      t.references :player, null: false

      t.timestamps null: false
    end
    add_index :ships, :location, using: :gin
    add_index :ships, [:game_id, :player_id]
  end
end
