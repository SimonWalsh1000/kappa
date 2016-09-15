class AddCountryToScores < ActiveRecord::Migration
  def change
    add_column :scores, :country, :string
  end
end
