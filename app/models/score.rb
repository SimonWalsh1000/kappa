# == Schema Information
#
# Table name: scores
#
#  id                      :integer          not null, primary key
#  case_id                 :integer
#  patient_id              :integer
#  user_id                 :integer
#  dx1                     :string
#  dx2                     :string
#  dx3                     :string
#  dx4                     :string
#  dx5                     :string
#  dxcon1                  :integer
#  dxcon2                  :integer
#  dxcon3                  :integer
#  dxcon4                  :integer
#  dxcon5                  :integer
#  job                     :string
#  description             :string
#  experience              :integer
#  institution             :string
#  fellowship              :string
#  meeting_type            :string
#  ipf_diagnostic_approach :string
#  mdt_frequency           :string
#  ipf_number_cases        :string
#  imaging                 :string
#  histopathology          :string
#  ipf                     :integer
#  hp                      :integer
#  nsip                    :integer
#  ctd                     :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  country                 :string
#  fname                   :string
#  lname                   :string
#  status                  :string
#  biopsy                  :string
#  cryo                    :string
#  fibroticbehaviour       :integer
#  treatment_required      :integer
#  limitedbehaviour        :integer
#  reversiblebehaviour     :integer
#  mgt                     :string
#  comment                 :string
#  continent               :string
#  strata                  :integer
#  cat                     :integer
#  email                   :string
#

class Score < ActiveRecord::Base

  include ScoresHelper

  attr_accessor :countries

  attr_accessor :experience_less

  scope :ild_mdt, -> { where(meeting_type: "Yes, I attend a dedicated ILD MDT meeting")}

  scope :gen_mdt, -> { where(meeting_type: "Yes, I attend a general respiratory MDT meeting")}

  scope :some_mdt, -> { where("meeting_type = ? or meeting_type = ?", "Yes, I attend a dedicated ILD MDT meeting", "Yes, I attend a general respiratory MDT meeting")}

  scope :no_mdt, -> { where(meeting_type: "No, I do not attend/have access to a regular respiratory MDT meeting")}

  scope :refer, -> { where(ipf_number_cases: "0.0")}

  scope :some_ipf, -> { where("ipf_number_cases = ? or ipf_number_cases = ? or ipf_number_cases = ?", "1.0", "2.0", "3,0")}

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

  scope :not_trainee, -> { where("fellowship != ?", "I am currently undergoing specialist training")}

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

  scope :frequent_mdt, -> { where("mdt_frequency = ? or mdt_frequency = ?", "Weekly", "Fortnightly")}

  scope :very_frequent_mdt, -> { where("mdt_frequency = ?", "Weekly")}

  scope :monthly_mdt, -> { where("mdt_frequency = ?", "Monthly")}

  scope :fortnightly_mdt, -> { where("mdt_frequency = ?", "Fortnightly")}

  scope :weekly_mdt, -> { where("mdt_frequency = ?", "Weekly")}

  scope :daily_mdt, -> { where("mdt_frequency = ?", "Daily")}

  scope :rare_mdt, -> { where("mdt_frequency = ?", "Less than once per month")}

  scope :not_weekly_mdt, -> { where("mdt_frequency = ? or mdt_frequency = ? or mdt_frequency = ?", "Less than once per month", "Fortnightly", "Monthly")}

  scope :expert_ipf, -> { where("dx1 = ? and status = ?", "Idiopathic pulmonary fibrosis", "true")}

  scope :imaging, -> { where(imaging: "Yes") }

  scope :histopathology, -> { where(histopathology: "Yes") }

  scope :no_imaging, -> { where(imaging: "No") }

  scope :no_histopathology, -> { where(histopathology: "No") }

  scope :indirect_imaging, -> { where(imaging: "Not directly, but in my network") }

  scope :indirect_histopathology, -> { where(histopathology: "Not directly, but in my network") }


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



  def adjusted_ipf_cat
    if self.dx1 == "Idiopathic pulmonary fibrosis"
      1
    elsif self.dx2 == "Idiopathic pulmonary fibrosis" && self.dxcon1 == 50 && self.dxcon2 == 50  && (self.mgt == "IPF-specific therapy (i.e. Nintedanib, Pirfenidone) assuming the patient satisfies local prescribing criteria." || self.mgt == "IPF-specific therapy, (i.e. Nintedanib, Pirfenidone), if it were available in my country" || self.mgt == "IPF-specific therapy (i.e. Nintedanib, Pirfenidone - one or both are available)" )
      1
    else
      0
    end
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
    number_of_columns = Score.all.map(&:user_id).uniq.count
    CSV.generate(options) do |csv|
      column_names = (1..number_of_columns).map {|i| "var" + i.to_s }
      csv << column_names
      i = 0
      60.times do
        i = i + 1
        row = Score.group(:user_id).count.sort_by {|_key, value| value}.map { |k, v| Score.where(user_id: k, case_id: i).first.diagnosis_cat }
        csv << row

      end
    end
  end

  # def self.to_ipf_csv(options = {})
  #   CSV.generate(options) do |csv|
  #     # Remember! for STATA you need to use the STUB "var" with NO UNDERSCORE
  #      column_names = Score.group(:user_id).count.map { |k, v|  "var" + Score.where(user_id: k).first.user_id.to_s  }
  #     csv << column_names
  #     i = 0
  #     60.times do
  #       i = i + 1
  #       row = Score.group(:user_id).count.map { |k, v| Score.where(user_id: k, case_id: i).first.ipf_cat }
  #       csv << row
  #     end
  #   end
  # end

  # THIS CODE IS FOR CHECKING THE "RESULTS" EXCEL SHEET - IT WILL GIVE YOU THE IPF CAT WITH THE PHYSICIANS NAME
  def self.to_ipf_csv(options = {})
    CSV.generate(options) do |csv|
      # Remember! for STATA you need to use the STUB "var" with NO UNDERSCORE
      column_names = Score.group(:user_id).count.map { |k, v|  Score.where(user_id: k).first.fname + "_" + Score.where(user_id: k).first.lname }
      # column_names = Score.group(:user_id).count.map { |k, v|  "var" + Score.where(user_id: k).first.user_id.to_s  }
      # column_names = Score.group(:user_id).count.map { |k, v|  Score.where(user_id: k).first.user_id}
      #  number_of_columns = Score.all.map(&:user_id).uniq.count
      # column_names = (1..number_of_columns).map {|i| "var" + i.to_s }
      csv << column_names
      # i = 0
      # 60.times do
      #   i = i + 1
      #    row = Score.group(:user_id).count.map { |k, v| Score.where(user_id: k, case_id: i).first.ipf_cat }
         row = Score.group(:user_id).count.map { |k, v| Score.where(user_id: k).first.user_id }
        csv << row
      # end
    end
  end

  def self.to_adjusted_ipf_csv(options = {})
    CSV.generate(options) do |csv|
      # Remember! for STATA you need to use the STUB "var" with NO UNDERSCORE
      column_names = Score.group(:user_id).count.map { |k, v|  Score.where(user_id: k).first.fname + "_" + Score.where(user_id: k).first.lname }
      number_of_columns = Score.all.map(&:user_id).uniq.count
      # column_names = (1..number_of_columns).map {|i| "var" + i.to_s }
      csv << column_names
      i = 0
      60.times do
        i = i + 1
        row = Score.group(:user_id).count.map { |k, v| Score.where(user_id: k, case_id: i).first.adjusted_ipf_cat }
        # row = Score.group(:user_id).count.map { |k, v| Score.where(user_id: k).first.user_id  }
        csv << row
      end
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

  def self.to_confidence_csv(options = {})
    CSV.generate(options) do |csv|

      @array = Array.new
      @array_result =  Score.expert.pluck(:dx1, :dxcon1).select{ |a,b| a == "Idiopathic pulmonary fibrosis" }.each do |a,b|
        b > 65 ? @array << 1 : @array << 0
      end
      csv << @array

      @array = Array.new
      @array_result =  Score.novice.pluck(:dx1, :dxcon1).select{ |a,b| a == "Idiopathic pulmonary fibrosis" }.each do |a,b|
        b > 65 ? @array << 1 : @array << 0
      end
      csv << @array

      @array = Array.new
      @array_result =  Score.university.pluck(:dx1, :dxcon1).select{ |a,b| a == "Idiopathic pulmonary fibrosis" }.each do |a,b|
        b > 65 ? @array << 1 : @array << 0
      end
      csv << @array

      @array = Array.new
      @array_result =  Score.non_university.pluck(:dx1, :dxcon1).select{ |a,b| a == "Idiopathic pulmonary fibrosis" }.each do |a,b|
        b > 65 ? @array << 1 : @array << 0
      end
      csv << @array

      @array = Array.new
      @array_result =  Score.weekly_mdt.pluck(:dx1, :dxcon1).select{ |a,b| a == "Idiopathic pulmonary fibrosis" }.each do |a,b|
        b > 65 ? @array << 1 : @array << 0
      end
      csv << @array

      @array = Array.new
      @array_result =  Score.no_mdt.pluck(:dx1, :dxcon1).select{ |a,b| a == "Idiopathic pulmonary fibrosis" }.each do |a,b|
        b > 65 ? @array << 1 : @array << 0
      end
      csv << @array

    end
  end

  def self.to_number_of_ipf_diagnoses_csv(options = {})
    CSV.generate(options) do |csv|
      # total
      csv << Score.where(dx1: "Idiopathic pulmonary fibrosis").group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}
      # experts
      csv << Score.expert.where(dx1: "Idiopathic pulmonary fibrosis").group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}
      # novice
      csv << Score.novice.where(dx1: "Idiopathic pulmonary fibrosis").group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}
      # university
      csv << Score.university.where(dx1: "Idiopathic pulmonary fibrosis").group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}
      # non-university
      csv << Score.non_university.where(dx1: "Idiopathic pulmonary fibrosis").group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}
      # weekly mdt
      csv << Score.weekly_mdt.where(dx1: "Idiopathic pulmonary fibrosis").group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}
      # no mdt
      csv << Score.no_mdt.where(dx1: "Idiopathic pulmonary fibrosis").group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}
    end
  end

  def self.to_number_of_high_confidence_ipf_diagnoses(options = {})
    CSV.generate(options) do |csv|
      # total
      csv << Score.where(dx1: "Idiopathic pulmonary fibrosis").reject{|s| s.dxcon1 < 70 }.group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}
      # experts
      csv << Score.expert.where(dx1: "Idiopathic pulmonary fibrosis").reject{|s| s.dxcon1 < 70 }.group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}
      # novice
      csv << Score.novice.where(dx1: "Idiopathic pulmonary fibrosis").reject{|s| s.dxcon1 < 70 }.group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}
      # university
      csv << Score.university.where(dx1: "Idiopathic pulmonary fibrosis").reject{|s| s.dxcon1 < 70 }.group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}
      # non-university
      csv << Score.non_university.where(dx1: "Idiopathic pulmonary fibrosis").reject{|s| s.dxcon1 < 70 }.group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}
      # weekly mdt
      csv << Score.weekly_mdt.where(dx1: "Idiopathic pulmonary fibrosis").reject{|s| s.dxcon1 < 70 }.group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}
      # no mdt
      csv << Score.no_mdt.where(dx1: "Idiopathic pulmonary fibrosis").reject{|s| s.dxcon1 < 70 }.group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}
    end
  end

  def self.to_number_of_ipf_diagnoses_wk_csv(options = {})
    CSV.generate(options) do |csv|
      # experts vs novice
      csv << Array.new(Score.expert.where(dx1: "Idiopathic pulmonary fibrosis").group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}.count,1) + Array.new(Score.novice.where(dx1: "Idiopathic pulmonary fibrosis").group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}.count,0)
      csv << Score.expert.where(dx1: "Idiopathic pulmonary fibrosis").group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]} + Score.novice.where(dx1: "Idiopathic pulmonary fibrosis").group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1].to_s}
      # uni vs not uni
      csv << Array.new(Score.university.where(dx1: "Idiopathic pulmonary fibrosis").group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}.count,1) + Array.new(Score.non_university.where(dx1: "Idiopathic pulmonary fibrosis").group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}.count,0)
      csv << Score.university.where(dx1: "Idiopathic pulmonary fibrosis").group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]} + Score.non_university.where(dx1: "Idiopathic pulmonary fibrosis").group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1].to_s}
      # mdt vs not mdt
      csv << Array.new(Score.weekly_mdt.where(dx1: "Idiopathic pulmonary fibrosis").group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}.count,1) + Array.new(Score.no_mdt.where(dx1: "Idiopathic pulmonary fibrosis").group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}.count,0)
      csv << Score.weekly_mdt.where(dx1: "Idiopathic pulmonary fibrosis").group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]} + Score.no_mdt.where(dx1: "Idiopathic pulmonary fibrosis").group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1].to_s}
    end
  end

  def self.to_number_of_high_confidence_ipf_diagnoses_wk_csv(options = {})
    CSV.generate(options) do |csv|
      # experts vs novice
      csv << Array.new(Score.expert.where(dx1: "Idiopathic pulmonary fibrosis").reject{|s| s.dxcon1 < 70 }.group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}.count,1) + Array.new(Score.novice.where(dx1: "Idiopathic pulmonary fibrosis").reject{|s| s.dxcon1 < 70 }.group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}.count,0)
      csv << Score.expert.where(dx1: "Idiopathic pulmonary fibrosis").reject{|s| s.dxcon1 < 70 }.group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]} + Score.novice.where(dx1: "Idiopathic pulmonary fibrosis").reject{|s| s.dxcon1 < 70 }.group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1].to_s}
      # uni vs not uni
      csv << Array.new(Score.university.where(dx1: "Idiopathic pulmonary fibrosis").reject{|s| s.dxcon1 < 70 }.group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}.count,1) + Array.new(Score.non_university.where(dx1: "Idiopathic pulmonary fibrosis").reject{|s| s.dxcon1 < 70 }.group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}.count,0)
      csv << Score.university.where(dx1: "Idiopathic pulmonary fibrosis").reject{|s| s.dxcon1 < 70 }.group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]} + Score.non_university.where(dx1: "Idiopathic pulmonary fibrosis").reject{|s| s.dxcon1 < 70 }.group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1].to_s}
      # mdt vs not mdt
      csv << Array.new(Score.weekly_mdt.where(dx1: "Idiopathic pulmonary fibrosis").reject{|s| s.dxcon1 < 70 }.group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}.count,1) + Array.new(Score.no_mdt.where(dx1: "Idiopathic pulmonary fibrosis").reject{|s| s.dxcon1 < 70 }.group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]}.count,0)
      csv << Score.weekly_mdt.where(dx1: "Idiopathic pulmonary fibrosis").reject{|s| s.dxcon1 < 70 }.group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1]} + Score.no_mdt.where(dx1: "Idiopathic pulmonary fibrosis").reject{|s| s.dxcon1 < 70 }.group_by(&:user_id).map{|k,v| [k, v.count] }.map{ |a| a[1].to_s}
    end
  end

    @expert_confident = (((Score.expert.pluck(:dx1, :dxcon1).select{ |a,b| a == "Idiopathic pulmonary fibrosis" && b > 65 }.count).to_f)*100/ @expert.to_f).round(1)

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |p|
        csv << p.attributes.values_at(*column_names)
      end
    end
  end


  end
