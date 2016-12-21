# == Schema Information
#
# Table name: clinicians
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  country    :string
#  society    :string
#  general    :string
#  specialty  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Clinician < ActiveRecord::Base


  scope :invited, -> { where(society: "INVITE")}

  scope :ild_specialist, -> { where(specialty: "ILD")}

  scope :not_ild_specialist, -> { where(specialty: nil)}

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      check = find_by_id(row["id"]) || new
      check.attributes = row.to_hash
      check.save!
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |p|
        csv << p.attributes.values_at(*column_names)
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path,options={})
      else raise "Unknown file type: #{file.original_filename}"
    end
  end



end
