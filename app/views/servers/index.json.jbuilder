json.array!(@servers) do |server|
  json.extract! server, :id, :name, :translated_name
  json.url server_url(server, format: :json)
end
