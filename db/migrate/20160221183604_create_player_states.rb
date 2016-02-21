class CreatePlayerStates < ActiveRecord::Migration
  def change
    create_table :player_states do |t|
      t.integer    :health
      t.jsonb      :grid

      t.references :game
      t.references :player

      t.timestamps null: false
    end
  end
end
