class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :job_description
      t.integer :experience
      t.string :institution
      t.string :institution_type
      t.string :ipf_approach
      t.string :meeting
      t.string :imaging
      t.string :histopathology
      t.string :fellowship
      t.string :mdt_frequency
      t.string :country
      t.string :ipfphys
      t.string :email
      t.string :cryobiopsy
      t.boolean :complete
      t.boolean :finished
      t.integer :finish
      t.boolean :author
      t.boolean :ats

      t.timestamps null: false
    end
  end
end
