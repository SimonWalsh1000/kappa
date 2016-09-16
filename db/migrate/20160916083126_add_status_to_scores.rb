class AddStatusToScores < ActiveRecord::Migration
  def change
    add_column :scores, :status, :string
  end
end
