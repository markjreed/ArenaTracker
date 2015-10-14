json.array!(@raw_battles) do |raw_battle|
  json.extract! raw_battle, :id, :raw_battle_data, :parse_status, :status_message
  json.url raw_battle_url(raw_battle, format: :json)
end
