class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.belongs_to :Player, index: true
      t.belongs_to :Match, index: true
      t.integer :player_faction
      t.integer :killing_blows
      t.integer :damage_done
      t.integer :healing_done
      t.integer :ratings_adjustment

      t.timestamps
    end
  end
end
