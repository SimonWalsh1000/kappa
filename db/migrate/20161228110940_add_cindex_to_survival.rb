class AddCindexToSurvival < ActiveRecord::Migration
  def change
    add_column :survivals, :c, :decimal, precision: 8, scale: 15
  end
end
