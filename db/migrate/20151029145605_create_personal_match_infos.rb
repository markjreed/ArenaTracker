class CreatePersonalMatchInfos < ActiveRecord::Migration
  def change
    create_table :personal_match_infos do |t|
      t.belongs_to :player, index: true
      t.belongs_to :match, index: true
      t.string :talents
      t.string :glyphs
      t.string :note
      t.integer :fight_number
      t.boolean :winner

      t.timestamps
    end
  end
end
