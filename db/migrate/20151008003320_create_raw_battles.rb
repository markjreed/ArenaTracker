class CreateRawBattles < ActiveRecord::Migration
  def change
    create_table :raw_battles do |t|
      t.text :raw_battle_data
      t.string :parse_status
      t.string :status_message

      t.timestamps
    end
  end
end
