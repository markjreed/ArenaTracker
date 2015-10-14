json.array!(@talent_glyph_selections) do |talent_glyph_selection|
  json.extract! talent_glyph_selection, :id, :tal01, :tal02, :tal03, :tal04, :tal05, :tal06, :tal07, :tal08, :gly01, :gly02, :gly03, :gly04, :gly05, :gly06, :gly07, :gly08, :gly09, :gly10
  json.url talent_glyph_selection_url(talent_glyph_selection, format: :json)
end
