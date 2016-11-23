class AddStrataToScores < ActiveRecord::Migration
  def change
    add_column :scores, :strata, :integer
  end
end
