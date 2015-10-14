class MatchTalentGlyphSelection < ActiveRecord::Base
  belongs_to :Player
  belongs_to :Match
  belongs_to :TalentGlyphSelection
end
