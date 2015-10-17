class FixColumnNamesInScores < ActiveRecord::Migration
  def change
     rename_column :scores, :Player_id, :old_player_id
     rename_column :scores, :old_player_id, :player_id
     rename_column :scores, :Match_id, :old_match_id
     rename_column :scores, :old_match_id, :match_id
  end
end
