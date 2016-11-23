class AddEmailToScores < ActiveRecord::Migration
  def change
    add_column :scores, :email, :string
  end
end
