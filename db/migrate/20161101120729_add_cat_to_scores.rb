class AddCatToScores < ActiveRecord::Migration
  def change
    add_column :scores, :cat, :integer
  end
end
