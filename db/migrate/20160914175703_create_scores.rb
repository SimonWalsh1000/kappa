class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :case_id
      t.integer :patient_id
      t.integer :user_id
      t.string :dx1
      t.string :dx2
      t.string :dx3
      t.string :dx4
      t.string :dx5
      t.integer :dxcon1
      t.integer :dxcon2
      t.integer :dxcon3
      t.integer :dxcon4
      t.integer :dxcon5
      t.string :job
      t.string :description
      t.integer :experience
      t.string :institution
      t.string :fellowship
      t.string :meeting_type
      t.string :ipf_diagnostic_approach
      t.string :mdt_frequency
      t.string :ipf_number_cases
      t.string :imaging
      t.string :histopathology
      t.integer :ipf
      t.integer :hp
      t.integer :nsip
      t.integer :ctd
      t.timestamps null: false
    end
  end
end
