class AddContinentToScores < ActiveRecord::Migration
  def change
    add_column :scores, :continent, :string
  end
end
