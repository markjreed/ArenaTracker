json.array!(@matches) do |match|
  json.extract! match, :id, :date_time, :arena_name, :winning_faction
  json.url match_url(match, format: :json)
end
