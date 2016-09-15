class AddNamesToScores < ActiveRecord::Migration
  def change
    add_column :scores, :fname, :string
    add_column :scores, :lname, :string
  end
end
