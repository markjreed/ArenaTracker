json.array!(@scores) do |score|
  json.extract! score, :id, :player_id, :match_id, :player_faction, :killing_blows, :damage_done, :healing_done, :ratings_adjustment
  json.url score_url(score, format: :json)
end
