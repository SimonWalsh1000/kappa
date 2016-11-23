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
