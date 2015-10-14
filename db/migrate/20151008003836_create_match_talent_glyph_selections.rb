class CreateMatchTalentGlyphSelections < ActiveRecord::Migration
  def change
    create_table :match_talent_glyph_selections do |t|
      t.belongs_to :Player, index: true
      t.belongs_to :Match, index: true
      t.belongs_to :TalentGlyphSelection, index: true

      t.timestamps
    end
  end
end
