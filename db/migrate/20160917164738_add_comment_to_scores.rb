class AddCommentToScores < ActiveRecord::Migration
  def change
    add_column :scores, :comment, :string
  end
end
