class AddReferenceToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :reference, :string
    add_column :matches, :mmr_list, :string
  end
end
