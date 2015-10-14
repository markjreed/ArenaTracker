class CreateTalentGlyphSelections < ActiveRecord::Migration
  def change
    create_table :talent_glyph_selections do |t|
      t.string :tal01
      t.string :tal02
      t.string :tal03
      t.string :tal04
      t.string :tal05
      t.string :tal06
      t.string :tal07
      t.string :tal08
      t.string :gly01
      t.string :gly02
      t.string :gly03
      t.string :gly04
      t.string :gly05
      t.string :gly06
      t.string :gly07
      t.string :gly08
      t.string :gly09
      t.string :gly10

      t.timestamps
    end
  end
end
