json.array!(@players) do |player|
  json.extract! player, :id, :name, :server_name, :class_name, :spec_name
  json.url player_url(player, format: :json)
end
