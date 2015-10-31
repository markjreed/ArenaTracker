class AddMatchEndToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :match_end, :datetime
  end
end
