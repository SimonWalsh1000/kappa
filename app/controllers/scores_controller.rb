class ScoresController < ApplicationController

  include ScoresHelper

  before_action :set_score, only: [:show, :edit, :update, :destroy]

  # GET /scores
  # GET /scores.json
  def index
    @hash = Hash.new
    Score.all.map(&:country).each do |c|
      result = ((Score.where("dx1 = ? and dxcon1 > ? and country = ? ", "Idiopathic pulmonary fibrosis", 70 , c).count) * (100) / (Score.where("dx1 = ? and  country = ? ", "Idiopathic pulmonary fibrosis", c).count))
      @hash[c] = [result, (Score.where("dx1 = ? and country = ? ", "Idiopathic pulmonary fibrosis", c).count)]
    end
  end

  def completed_breakdown
  end

  def analysis
    @score_count = Score.count
    @user_array = Score.group(:user_id).count.sort_by {|_key, value| value}.map { |k, v| k }
    kappa(6, 8, "ipf")
    @rater1_id = 6
    @rater2_id = 8
  end

  def experience
    # @query_over_5 = get_users(options = { experience_lower: 6 } )
    # @query_less_than_equal_to_5 = get_users(options = { experience_upper: 5} )
    # @query_over_10 = get_users(options = { experience_lower: 11 } )
    # @query_less_than_equal_to_10 = get_users(options = { experience_upper: 10} )
    # @query_over_15 = get_users(options = { experience_lower: 16 } )
    # @query_less_than_equal_to_15 = get_users(options = { experience_upper: 15} )
    @query_over_20 = get_users(options = { experience_lower: 21 } )
    @query_less_than_equal_to_20 = get_users(options = { experience_upper: 20} )
    # @query_over_25 = get_users(options = { experience_lower: 26 } )
    # @query_less_than_equal_to_25 = get_users(options = { experience_upper: 25} )
    # @query_over_30 = get_users(options = { experience_lower: 31 } )
    # @query_less_than_equal_to_30 = get_users(options = { experience_upper: 30} )
    # @kappas_over_5 = get_kappas(@query_over_5, "ipf")
    # @kappas_less_than_equal_to_5 = get_kappas(@query_less_than_equal_to_5, "ipf")
    # @kappas_over_10 = get_kappas(@query_over_10, "ipf")
    # @kappas_less_than_equal_to_10 = get_kappas(@query_less_than_equal_to_10, "ipf")
    # @kappas_over_15 = get_kappas(@query_over_15, "ipf")
    # @kappas_less_than_equal_to_15 = get_kappas(@query_less_than_equal_to_15, "ipf")
    @kappas_over_20 = get_kappas(@query_over_20, "ipf")
    @kappas_less_than_equal_to_20 = get_kappas(@query_less_than_equal_to_20, "ipf")
    # @kappas_over_25 = get_kappas(@query_over_25, "ipf")
    # @kappas_less_than_equal_to_25 = get_kappas(@query_less_than_equal_to_25, "ipf")
    # @kappas_over_30 = get_kappas(@query_over_30, "ipf")
    # @kappas_less_than_equal_to_30 = get_kappas(@query_less_than_equal_to_30, "ipf")
  end

  def multiple_kappas
    if  params.has_key?(:institution) &&
        params.has_key?(:experience) &&
        params.has_key?(:experience_less) &&
        params.has_key?(:countries) &&
        params.has_key?(:meeting_type) &&
        params.has_key?(:ipf_number_cases)
          @score_count = Score.count
          @score = Score.new
          @countries = Score.all.group(:country).count.sort_by {|_key, value| value}.map { |k, v| [k, k] } << "All" << "Deselect"
          @experience = (1..50).to_a << "All" << "Deselect"
          @ipf = (0..2).to_a.map(&:to_s) << "All" << "Deselect"
          @query = get_users(options = { institution: params[:institution], experience_lower: params[:experience], experience_upper: params[:experience_less], country: params[:countries], meeting: params[:meeting_type], ipf_number: params[:ipf_number_cases]} )
          @names = @query.map { |s| Score.where(user_id: s).first.name.titleize }
          @kappas = get_kappas(@query, "ipf")
    else
      @score_count = Score.count
      @score = Score.new
      @countries = Score.all.group(:country).count.sort_by {|_key, value| value}.map { |k, v| [k, k] } << "All" << "Deselect"
      @experience = (1..50).to_a  << "All" << "Deselect"
      @ipf = (0..2).to_a.map(&:to_s)  << "All" << "Deselect"
    end
  end

  def all_kappas
    @query = get_users(options = {})
    @names = @query.map { |s| Score.where(user_id: s).first.name.titleize }
    @kappas_ipf = get_kappas(@query, "ipf")
    @kappas_ctd = get_kappas(@query, "ctd")
    @kappas_nsip = get_kappas(@query, "nsip")
    @kappas_hp = get_kappas(@query, "hp")
  end

  def test
    @score_count = Score.count
    @score = Score.new
    @countries = Score.all.group(:country).count.sort_by {|_key, value| value}.map { |k, v| [k, k] } << ""
    @experience = (1..50).to_a << ""
    @ipf = (0..2).to_a.map(&:to_s) << ""
    @query = get_users(options = { institution: params[:institution], experience_lower: params[:experience], experience_upper: params[:experience_less], country: params[:countries], meeting: params[:meeting_type], ipf_number: params[:ipf_number_cases]} )
    @names = @query.map { |s| Score.where(user_id: s).first.name.titleize }
    @kappas = get_kappas(@query, "ipf")
    render 'multiple_kappas'
  end

   def countries_kappa
    @kappas = Hash.new
    @countries = Score.group(:country).count.map { |k, v| k }
    @countries.each do |c|
      next if median(get_kappas(get_users(options = { country: c}), "ipf")).blank?
      user_count_for_country = Score.where(country: c).count/60
      experience_count_for_country = Score.where(country: c).map {|s| s.experience }.uniq.sum/user_count_for_country
      @kappas[c] = [user_count_for_country, experience_count_for_country, median_and_ci(get_kappas(get_users(options = { country: c}), "ipf"))]
    end
    @kappas
   end

  def countries_demo
    @countries = Score.all.map(&:country).uniq
    @demographics = Hash.new
    @countries.each do |c|
      user_count_for_country = Score.where(country: c).count/60
      mdt_array = [Score.where(country: c).ild_mdt.count/60, Score.where(country: c).gen_mdt.count/60, Score.where(country: c).no_mdt.count/60]
      experts = [Score.where(country: c).expert.count/60, Score.where(country: c).novice.count/60]
      uni = [Score.where(country: c).university.count/60, Score.where(country: c).non_university.count/60]
      @demographics[c] = [user_count_for_country, mdt_array, experts, uni]
    end
    @demographics.sort_by{ |a,b| b[0]}
  end

  def discrepancy
    # @scores = Score.all.map { |score| score.check_diagnoses("Idiopathic pulmonary fibrosis", 20, score.case_id, score.name, score.experience)}.compact.sort_by { |k| k.keys[0][1]}
    @scores = Score.expert.all.map { |score| score.check_diagnoses_generic(15, score.case_id, score.name, score.experience)}.compact.sort_by { |k| k.keys[0][2]}
  end



  def export
    @kappa_statement = "kap " + Score.group(:user_id).count.sort_by {|_key, value| value}.map { |k, v| k }.map { |var| "var" + var.to_s }.join(" ")
    @variables = (1..(Score.group(:user_id).count.sort_by {|_key, value| value}.map { |k, v| k }.count)).to_a.map { |var| "var" + var.to_s }.join(" ")
  end

  def export_ipf
    @kappa_statement = "kap " + Score.group(:user_id).count.sort_by {|_key, value| value}.map { |k, v| k }.map { |var| "var" + var.to_s }.join(" ")
    @variables = (1..(Score.group(:user_id).count.sort_by {|_key, value| value}.map { |k, v| k }.count)).to_a.map { |var| "var" + var.to_s }.join(" ")
    @test = Score.where(lname: "Rokadia")

  end

  def export_adjusted_ipf
    @kappa_statement = "kap " + Score.group(:user_id).count.sort_by {|_key, value| value}.map { |k, v| k }.map { |var| "var" + var.to_s }.join(" ")
    @variables = (1..(Score.group(:user_id).count.sort_by {|_key, value| value}.map { |k, v| k }.count)).to_a.map { |var| "var" + var.to_s }.join(" ")
    @test = Score.where(lname: "Rokadia")
    @adjusted_scores = Score.all.select { |s| s.dx2 == "Idiopathic pulmonary fibrosis" && s.dxcon1 == 50 && s.dxcon2 == 50  && (s.mgt == "IPF-specific therapy (i.e. Nintedanib, Pirfenidone) assuming the patient satisfies local prescribing criteria." || s.mgt == "IPF-specific therapy, (i.e. Nintedanib, Pirfenidone), if it were available in my country" || s.mgt == "IPF-specific therapy (i.e. Nintedanib, Pirfenidone - one or both are available)" )}
  end

  def management
    @scores = Score.order(:id)
    respond_to do |format|
      format.html
      format.csv { send_data @scores.to_management_csv }
      format.xls
    end
  end

  def ipf
    @scores = Score.order(:id)
    respond_to do |format|
      format.html
      format.csv { send_data @scores.to_ipf_csv }
      format.xls
    end
  end

  def ipf_adjusted
    @scores = Score.order(:id)
    respond_to do |format|
      format.html
      format.csv { send_data @scores.to_adjusted_ipf_csv }
      format.xls
    end
  end

  def diagnosis
    @scores = Score.order(:id)
    respond_to do |format|
      format.html
      format.csv { send_data @scores.to_diagnosis_csv }
      format.xls
    end
  end

  def export_diagnosis
    @kappa_statement = "kap " + Score.group(:user_id).count.sort_by {|_key, value| value}.map { |k, v| k }.map { |var| "var" + var.to_s }.join(" ")
    @variables = (1..(Score.group(:user_id).count.sort_by {|_key, value| value}.map { |k, v| k }.count)).to_a.map { |var| "var" + var.to_s }.join(" ")
    @test = Score.where(lname: "Wilsher")

  end

  # GET /scores/1
  # GET /scores/1.json
  def show
  end

  # GET /scores/new
  def new
    @score = Score.new
  end

  # GET /scores/1/edit
  def edit
  end

  # POST /scores
  # POST /scores.json
  def create
    @score = Score.new(score_params)

    respond_to do |format|
      if @score.save
        format.html { redirect_to @score, notice: 'Score was successfully created.' }
        format.json { render :show, status: :created, location: @score }
      else
        format.html { render :new }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scores/1
  # PATCH/PUT /scores/1.json
  def update
    respond_to do |format|
      if @score.update(score_params)
        format.html { redirect_to @score, notice: 'Score was successfully updated.' }
        format.json { render :show, status: :ok, location: @score }
      else
        format.html { render :edit }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scores/1
  # DELETE /scores/1.json
  def destroy
    @score.destroy
    respond_to do |format|
      format.html { redirect_to scores_url, notice: 'Score was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def nuclear
    @scores = Score.all
    @scores.map { |s| s.destroy}
    respond_to do |format|
      format.html { redirect_to upload_scores_path, notice: 'Score was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload
    render 'uploader'
  end

  def import
    Score.import(params[:file])
    redirect_to analysis_scores_path, notice: "Scores imported."
  end

  def authors

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_score
      @score = Score.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def score_params
      params.require(:score).permit(:Countries, :case_id, :user_id, :dx1, :dx2, :dx3, :dx5, :dxcon2, :dxcon4, :job, :description, :experience, :fellowship, :meeting_type, :mdt_frequency, :ipf_number_cases, :imaging, :histopathology, :nsip, :ctd)
    end
end
