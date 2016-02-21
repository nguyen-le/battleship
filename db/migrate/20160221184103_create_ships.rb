class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.string     :ship_type
      t.jsonb      :location

      t.references :game
      t.references :player

      t.timestamps null: false
    end
  end
end
