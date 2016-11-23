class Score < ActiveRecord::Base

  include ScoresHelper

  attr_accessor :countries

  attr_accessor :experience_less

  scope :ild_mdt, -> { where(meeting_type: "Yes, I attend a dedicated ILD MDT meeting")}

  scope :gen_mdt, -> { where(meeting_type: "Yes, I attend a general respiratory MDT meeting")}

  scope :no_mdt, -> { where(meeting_type: "No, I do not attend/have access to a regular respiratory MDT meeting")}

  scope :refer, -> { where(ipf_number_cases: "0.0")}

  scope :ipf_one, -> { where(ipf_number_cases: "1.0")}

  scope :ipf_two, -> { where(ipf_number_cases: "2.0")}

  scope :ipf_three, -> { where(ipf_number_cases: "3.0")}

  scope :ipf_under_ten, -> { where("ipf_number_cases = ? or ipf_number_cases = ?", "0.0", "1.0")}

  scope :ipf_ten, -> { where("ipf_number_cases = ? or ipf_number_cases = ?", "2.0", "3.0")}

  scope :university, -> { where(institution: "University hospital")}

  scope :non_university, -> { where(institution: "Non-university hospital")}

  scope :expert, -> { where(status: "true")}

  scope :novice, -> { where(status: "false")}

  scope :fellow, -> { where(fellowship: "Yes")}

  scope :not_fellow, -> { where(fellowship: "No")}

  scope :asia, -> { where(continent: "Asia")}

  scope :europe, -> { where(continent: "Europe")}

  scope :america, -> { where(continent: "Americas")}

  scope :me, -> { where(continent: "Middle -East")}

  scope :oceania, -> { where(continent: "Oceania")}

  scope :strata_one, -> { where("strata = ? or strata = ? or strata = ?", 0,1,2)}

  scope :strata_two, -> { where("strata = ? or strata = ? or strata = ?", 3,4,5)}

  scope :strata_three, -> { where("strata = ? or strata = ? or strata = ?", 6,7,8)}

  scope :cat_one, -> { where("cat = ? or cat = ? or cat = ?", 0,1,2)}

  scope :cat_two, -> { where("cat = ? or cat = ? or cat = ? or cat = ?", 3,4,5,6)}



  before_save :stratify

  def stratify
    if self.meeting_type == "No, I do not attend/have access to a regular respiratory MDT meeting"
      @value = 0
    elsif self.meeting_type == "Yes, I attend a general respiratory MDT meeting"
      @value = 1
    else self.meeting_type == "Yes, I attend a dedicated ILD MDT meeting"
      @value = 2
    end
    #
    if self.institution == "Non-university hospital"
      @value = 0 + @value
    elsif self.institution == "University hospital"
      @value = 1 + @value
    end
    #
    if self.ipf_number_cases == "0.0"
      @value = 0 + @value
    elsif self.ipf_number_cases == "1.0"
      @value = 1 + @value
    elsif self.ipf_number_cases == "2.0"
      @value = 2 + @value
    elsif self.ipf_number_cases == "3.0"
     @value = 3 + @value
    end
    #
    # if self.experience < 10
    #   @value = 0 + @value
    # elsif self.experience >= 10 && self.experience < 20
    #   @value = 1 + @value
    # elsif self.experience >= 20
    #   @value = 2 + @value
    # end
    self.cat = @value
  end

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

  def check_diagnoses_generic(threshold, case_number, name, exp)
    unless self.dx2.nil? || self.dxcon2.nil?
        if (self.dxcon1 - self.dxcon2).abs < threshold
          Hash[[self.dx1, self.dx2, case_number, name, exp]=>[self.dxcon1, self.dxcon2, case_number, name, exp]]
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

  def ipf_cat
    self.dx1 == "Idiopathic pulmonary fibrosis" ? 1 : 0
  end

  def diagnosis_cat
    case self.dx1
      when "Idiopathic pulmonary fibrosis"
        return 1
      when "Hypersensitivity pneumonitis"
        return 2
      when "Connective tissue disease related ILD"
        return 3
      when "Idiopathic non-specific interstitial pneumonia"
        return 4
      when "Other (please provide a comment below)"
        return 5
      when "Organizing pneumonia"
        return 6
      when "Occupational lung disease"
        return 7
      when "Unclassifiable ILD"
        return 8
      when "Idiopathic pleuroparenchymal fibroelastosis"
        return 9
      when "Sarcoidosis"
        return 10
      when "RBILD/DIP"
        return 11
      when "Drug induced lung disease"
        return 12
      else
        return false
    end
  end


  # adjust this code to get subgroups

  def self.to_diagnosis_csv(options = {})
    number_of_columns = Score.novice.all.map(&:user_id).uniq.count
    CSV.generate(options) do |csv|
      column_names = (1..number_of_columns).map {|i| "var" + i.to_s }
      csv << column_names
      i = 0
      60.times do
        i = i + 1
        row = Score.novice.group(:user_id).count.sort_by {|_key, value| value}.map { |k, v| Score.where(user_id: k, case_id: i).first.diagnosis_cat }
        csv << row

      end
    end
  end

  # def self.to_ipf_csv(options = {})
  #   # number_of_columns = Score.all.map(&:user_id).uniq.count
  #   CSV.generate(options) do |csv|
  #     # column_names = (1..number_of_columns).map {|i| "var" + i.to_s }
  #     column_names = Score.group(:user_id).count.sort_by {|_key, value| value}.map { |k, v| Score.where(user_id: k).first.fname.downcase + "_" + Score.where(user_id: k).first.user_id.to_s  }
  #     csv << column_names
  #     i = 0
  #     60.times do
  #       i = i + 1
  #       row = Score.group(:user_id).count.sort_by {|_key, value| value}.map { |k, v| Score.where(user_id: k, case_id: i).first.ipf_cat }
  #       csv << row
  #
  #     end
  #   end
  # end

  def self.to_ipf_csv(options = {})
    # number_of_columns = Score.all.map(&:user_id).uniq.count
    CSV.generate(options) do |csv|
      # column_names = (1..number_of_columns).map {|i| "var" + i.to_s }
      column_names = Score.group(:user_id).count.sort_by {|_key, value| value}.map { |k, v| Score.where(user_id: k).first.user_id }
      csv << column_names
      # i = 0
      # 60.times do
      #   i = i + 1
      #   row = Score.group(:user_id).count.sort_by {|_key, value| value}.map { |k, v| Score.where(user_id: k, case_id: i).first.ipf_cat }
      #   csv << row
      #
      # end
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
