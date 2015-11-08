class LinkPlayersAndServers < ActiveRecord::Migration
  def up
    change_table :players do |t|
       t.integer :server_id
    end
    Player.all.each do |p|
      p.server = Server.find_or_create_by_name(p.server_name)
    end
    change_table :players do |t|
      t.remove :server_name
    end
  end
  def down
    change_table :players do |t|
       t.string :server_name
    end
    Player.all.each do |p|
      p.server_name = p.server.name
    end
    change_table :players do |t|
      t.remove :server_id
    end
  end
end
