class Score < ActiveRecord::Base

  include ScoresHelper

  attr_accessor :countries

  attr_accessor :experience_less

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

  def name
    self.lname + " " + self.fname
  end

  def check_diagnoses(disease, threshold, case_number, name, exp)
    unless self.dx2.nil? || self.dxcon2.nil?
      if (self.dx1 == disease || self.dx2 == disease)
        if (self.dxcon1 - self.dxcon2).abs < threshold
          self.dx1 == disease ? Hash[[self.dx1, self.dx2, case_number, name, exp]=>[self.dxcon1, self.dxcon2, case_number, name, exp]] : Hash[[self.dx2, self.dx1,case_number, name, exp]=>[self.dxcon2, self.dxcon1, case_number, name, exp]]
        end
      end
    end
  end

  def mgt_types
    if self.mgt == "Observation"
      return "0"
    elsif self.mgt == "Immunomodulation"
      return "1"
    elsif self.mgt == "IPF-specific therapy (i.e. Nintedanib, Pirfenidone) assuming the patient satisfies local prescribing criteria."
      return "2"
    elsif self.mgt == "IPF-specific therapy (i.e. Nintedanib, Pirfenidone - one or both are available)"
      return "2"
    elsif self.mgt == "IPF-specific therapy, (i.e. Nintedanib, Pirfenidone), if it were available in my country"
      return "2"
    elsif self.mgt == "Other (e.g GM-CSF for alveolar proteinosis. Please specify in the comments)"
      return "3"
    end
  end

  def self.to_management_csv(options = {})
    CSV.generate(options) do |csv|
      column_names = Score.group(:user_id).count.sort_by {|_key, value| value}.map { |k, v| k }
      csv << column_names
      i = 0
      60.times do
        i = i + 1
        row = Score.group(:user_id).count.sort_by {|_key, value| value}.map { |k, v| Score.where(user_id: k, case_id: i).first.mgt_types }
        csv << row
      end
    end
  end


  end
