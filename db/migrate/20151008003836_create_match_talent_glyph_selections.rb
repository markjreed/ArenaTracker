class CreateMatchTalentGlyphSelections < ActiveRecord::Migration
  def change
    create_table :match_talent_glyph_selections do |t|
      t.belongs_to :player, index: true
      t.belongs_to :match, index: true
      t.belongs_to :talent_glyph_selection, index: { 
        name: 'index_match_talent_glyph_selection_on_talent_glyph_selection_id'
      }
      t.timestamps
    end
  end
end
