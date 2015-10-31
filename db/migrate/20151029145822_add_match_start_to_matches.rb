class AddMatchStartToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :match_start, :datetime
  end
end
