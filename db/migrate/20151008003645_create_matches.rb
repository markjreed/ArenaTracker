class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :date_time
      t.string :arena_name
      t.integer :winning_faction

      t.timestamps
    end
  end
end
