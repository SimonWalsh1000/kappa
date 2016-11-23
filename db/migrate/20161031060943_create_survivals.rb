class CreateSurvivals < ActiveRecord::Migration
  def change
    create_table :survivals do |t|
      t.integer :user_id
      t.string :name
      t.float :b
      t.float :se
      t.float :hr
      t.float :ci_lower
      t.float :ci_upper
      t.float :p

      t.timestamps null: false
    end
  end
end
