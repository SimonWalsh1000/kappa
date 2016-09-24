class AddManagementToScores < ActiveRecord::Migration
  def change
    add_column :scores, :biopsy, :string
    add_column :scores, :cryo, :string
    add_column :scores, :fibroticbehaviour, :integer
    add_column :scores, :treatment_required, :integer
    add_column :scores, :limitedbehaviour, :integer
    add_column :scores, :reversiblebehaviour, :integer
    add_column :scores, :mgt, :string
  end
end
