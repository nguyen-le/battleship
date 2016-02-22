class CreateShots < ActiveRecord::Migration
  def change
    create_table :shots do |t|
      t.string :location, null: false

      t.references :game, null: false
      t.references :user, null: false
      t.references :receiving_player, null: false

      t.timestamps null: false
    end
    add_index :shots, [:game_id, :user_id, :location], unique: true
  end
end
