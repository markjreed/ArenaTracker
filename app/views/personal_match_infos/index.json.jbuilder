json.array!(@personal_match_infos) do |personal_match_info|
  json.extract! personal_match_info, :id, :player_id, :match_id, :talents, :glyphs, :note, :fight_number, :winner
  json.url personal_match_info_url(personal_match_info, format: :json)
end
