# == Schema Information
#
# Table name: survivals
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string
#  b          :float
#  se         :float
#  hr         :float
#  ci_lower   :float
#  ci_upper   :float
#  p          :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Survival < ActiveRecord::Base


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

  def self.expert
    Survival.all.select {|s| Score.find(s.user_id).status == "true"}
  end



end
