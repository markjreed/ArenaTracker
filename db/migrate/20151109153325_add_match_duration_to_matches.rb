class AddMatchDurationToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :match_duration, :datetime
  end
end
