class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :server_name
      t.string :class_name
      t.string :spec_name

      t.timestamps
    end
  end
end
