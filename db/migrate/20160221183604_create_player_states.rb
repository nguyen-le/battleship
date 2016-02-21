class CreatePlayerStates < ActiveRecord::Migration
  def change
    create_table :player_states do |t|
      t.integer    :health, null: false
      t.jsonb      :grid, null: false

      t.references :game, null: false
      t.references :user, null: false, index: true

      t.timestamps null: false
    end
    add_index :player_states, :grid, using: :gin
    add_index :player_states, [:game_id, :user_id], unique: true
  end
end
