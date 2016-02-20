class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :status, default: 'PENDING', index: true

      t.references :owner, null: false, index: true
      t.references :opponent, null: false, index: true
      t.references :current_attacker, index: true
      t.references :winning_player, default: 0, index: true

      t.timestamps null: false
    end
  end
end
