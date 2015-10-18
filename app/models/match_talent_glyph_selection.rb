class MatchTalentGlyphSelection < ActiveRecord::Base
  belongs_to :player
  belongs_to :match
  belongs_to :talent_glyph_selection
end
