# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  first_name       :string
#  last_name        :string
#  job_description  :string
#  experience       :integer
#  institution      :string
#  institution_type :string
#  ipf_approach     :string
#  meeting          :string
#  imaging          :string
#  histopathology   :string
#  fellowship       :string
#  mdt_frequency    :string
#  country          :string
#  ipfphys          :string
#  email            :string
#  cryobiopsy       :string
#  complete         :boolean
#  finished         :boolean
#  finish           :integer
#  author           :boolean
#  ats              :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class User < ActiveRecord::Base


  scope :finished, -> { where(finished: true)}

  scope :not_finished, -> { where(finished: nil)}

  scope :expert, -> { where(author: true)}

  scope :novice, -> { where(author: false)}

  scope :lazy, -> { where(finish: 0) }

  scope :active, -> { where(finish: 1...60) }

  scope :lazy_active, -> { where(finish: 0...60) }

  scope :author, -> { where(author: true) }

  scope :not_author, -> { where(author: false) }

  scope :collaborator, -> { where(author: false, finish: 1..60) }

  scope :abstract, -> { where(ats: true) }

  scope :imaging, -> { where(imaging: "Yes") }

  scope :histopathology, -> { where(histopathology: "Yes") }

  scope :fellowship, -> { where(fellowship: "Yes") }

  scope :training_fellowship, -> { where(fellowship: "I am currently undergoing specialist training") }

  scope :no_imaging, -> { where(imaging: "No") }

  scope :no_histopathology, -> { where(histopathology: "No") }

  scope :indirect_imaging, -> { where(imaging: "Not directly, but in my network") }

  scope :indirect_histopathology, -> { where(histopathology: "Not directly, but in my network") }

  scope :no_fellowship, -> { where(fellowship: "No") }

  scope :ild_mdt, -> { where(meeting: "Yes, I attend a dedicated ILD MDT meeting")}

  scope :gen_mdt, -> { where(meeting: "Yes, I attend a general respiratory MDT meeting")}

  scope :no_mdt, -> { where(meeting: "No, I do not attend/have access to a regular respiratory MDT meeting")}

  scope :refer, -> { where(ipfphys: "0.0")}

  scope :ipf_one, -> { where(ipfphys: "1..10")}

  scope :ipf_two, -> { where(ipfphys: "11..20")}

  scope :ipf_three, -> { where(ipfphys: "20+")}

  scope :university, -> { where(institution_type: "University hospital")}

  scope :non_university, -> { where(institution_type: "Non-university hospital")}

  scope :cryobiopsy, -> { where(cryobiopsy: "Yes")}

  scope :no_cryobiopsy, -> { where(cryobiopsy: "No")}

  scope :monthly_mdt, -> { where("mdt_frequency = ?", "Monthly")}

  scope :fortnightly_mdt, -> { where("mdt_frequency = ?", "Fortnightly")}

  scope :weekly_mdt, -> { where("mdt_frequency = ?", "Weekly")}

  scope :daily_mdt, -> { where("mdt_frequency = ?", "Daily")}

  scope :rare_mdt, -> { where("mdt_frequency = ?", "Less than once per month")}

  scope :not_weekly_mdt, -> { where("mdt_frequency = ? or mdt_frequency = ? or mdt_frequency = ?", "Less than once per month", "Fortnightly", "Monthly")}


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

  def comparisons
    [self.author ? 1:0,
     self.institution_type == "University hospital" ? 1:0,
     self.first_name,
     self.last_name,
     self.experience,
     self.fellowship == "Yes" ? 1:0,
     self.meeting== "No, I do not attend/have access to a regular respiratory MDT meeting" ? 0:1,
     self.mdt_frequency == "Daily" ? 1:0,
     self.mdt_frequency == "Weekly" ? 1:0,
     self.mdt_frequency == "Fortnightly" ? 1:0,
     self.mdt_frequency == "Monthly" ? 1:0,
     self.mdt_frequency == "Less than once per month" ? 1:0,
     self.ipfphys == "0.0" ? 1:0,
     self.ipfphys == "1.0" ? 1:0,
     self.ipfphys == "2.0" ? 1:0,
     self.ipfphys == "3.0" ? 1:0,
     self.imaging == "Yes" ? 1:0,
     self.imaging == "Not directly, but in my network" ? 1:0,
     self.imaging == "No" ? 1:0,
     self.histopathology == "Yes" ? 1:0,
     self.histopathology == "Not directly, but in my network" ? 1:0,
     self.histopathology == "No" ? 1:0,
     self.cryobiopsy == "Yes" ? 1:0]
  end



  def self.export_comparisons(options = {})
    CSV.generate(options) do |csv|
      column_names = ["expert","academic", "first", "last", "exp", "fellow", "mdt", "daily", "weekly", "fortnight", "monthly", "rare", "refer", "ten", "20", "20plus", "rad", "indirect_rad", "no_rad", "path", "indirect_path", "no_path", "cryo"]
      csv << column_names
      User.finished.each do |u|
        row = u.comparisons
        csv << row
      end
    end
  end


























end
