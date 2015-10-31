class ChangeDataTypeOfMatchesColumns < ActiveRecord::Migration
  def change 
     remove_column :matches, :reference
     remove_column :matches, :mmr_list
     add_column :matches, :reference, :text
     add_column :matches, :mmr_list, :text
  end
end
