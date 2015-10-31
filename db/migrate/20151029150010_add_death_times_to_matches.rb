class AddDeathTimesToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :death_times, :text
  end
end
