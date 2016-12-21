class SurvivalsController < ApplicationController

  include ScoresHelper

  include SurvivalsHelper

  before_action :set_survival, only: [:show, :edit, :update, :destroy]

  # GET /survivals
  # GET /survivals.json
  def index
    @survivals = Survival.all
    @median_hr = median_and_ci(Survival.all.map(&:hr))
    @statistically_significant = Survival.all.map(&:p).reject {|p| p > 0.05}.count
    @total = Survival.all.map(&:p).count
  end

  # GET /survivals/1
  # GET /survivals/1.json
  def show
  end

  # GET /survivals/new
  def new
    @survival = Survival.new
  end

  # GET /survivals/1/edit
  def edit
  end

  # POST /survivals
  # POST /survivals.json
  def create
    @survival = Survival.new(survival_params)

    respond_to do |format|
      if @survival.save
        format.html { redirect_to @survival, notice: 'Survival was successfully created.' }
        format.json { render :show, status: :created, location: @survival }
      else
        format.html { render :new }
        format.json { render json: @survival.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /survivals/1
  # PATCH/PUT /survivals/1.json
  def update
    respond_to do |format|
      if @survival.update(survival_params)
        format.html { redirect_to @survival, notice: 'Survival was successfully updated.' }
        format.json { render :show, status: :ok, location: @survival }
      else
        format.html { render :edit }
        format.json { render json: @survival.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /survivals/1
  # DELETE /survivals/1.json
  def destroy
    @survival.destroy
    respond_to do |format|
      format.html { redirect_to survivals_url, notice: 'Survival was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload
    render 'uploader'
  end

  def import
    Survival.import(params[:file])
    redirect_to analysis_scores_path, notice: "Survivals imported."
  end

  def results

    # analysis group 1
    ids1 = Score.some_ipf.map(&:user_id).uniq
    @users1 = Score.not_weekly_mdt.university.map(&:fname).uniq
    @survivals1 = Survival.where(user_id: ids1)
    @survivals_count1 = @survivals1.count
    @not_significant1 = @survivals1.select {|s| s.p > 0.05 }
    @significant1 = @survivals1.select {|s| s.p <= 0.05 }
    @hazards1 = @survivals1.map(&:hr)
    @coefficient1 = @survivals1.map(&:b)

    # analysis group 2
    ids2 = Score.refer.map(&:user_id).uniq
    @users2 = Score.no_mdt.university.map(&:fname).uniq
    @survivals2 = Survival.where(user_id: ids2)
    @survivals_count2 = @survivals2.count
    @not_significant2 = @survivals2.select {|s| s.p > 0.05 }
    @significant2 = @survivals2.select {|s| s.p <= 0.05 }
    @hazards2 = @survivals2.map(&:hr)
    @coefficient2 = @survivals2.map(&:b)

  end

  def results_breakdown
    ids1 = Score.some_mdt.map(&:user_id).uniq
    @users1 = Score.some_mdt.map(&:fname).uniq
    @survivals1 = Survival.where(user_id: ids1)
    @survivals_count1 = @survivals1.count
    @not_significant1 = @survivals1.select {|s| s.p > 0.05 }
    @significant1 = @survivals1.select {|s| s.p <= 0.05 }
    @hazards1 = @survivals1.map(&:hr)
    @coefficient1 = @survivals1.map(&:b)
    ids2 = Score.no_mdt.map(&:user_id).uniq
    @users2 = Score.no_mdt.map(&:fname).uniq
    @survivals2 = Survival.where(user_id: ids2)
    @survivals_count2 = @survivals2.count
    @not_significant2 = @survivals2.select {|s| s.p > 0.05 }
    @significant2 = @survivals2.select {|s| s.p <= 0.05 }
    @hazards2 = @survivals2.map(&:hr)
    @coefficient2 = @survivals2.map(&:b)

    ids3 = Score.university.map(&:user_id).uniq
    @users3 = Score.university.map(&:fname).uniq
    @survivals3 = Survival.where(user_id: ids3)
    @survivals_count3 = @survivals3.count
    @not_significant3 = @survivals3.select {|s| s.p > 0.05 }
    @significant3 = @survivals3.select {|s| s.p <= 0.05 }
    @hazards3= @survivals3.map(&:hr)
    @coefficient3 = @survivals3.map(&:b)
    ids4 = Score.non_university.map(&:user_id).uniq
    @users4 = Score.non_university.map(&:fname).uniq
    @survivals4 = Survival.where(user_id: ids4)
    @survivals_count4 = @survivals4.count
    @not_significant4 = @survivals4.select {|s| s.p > 0.05 }
    @significant4 = @survivals4.select {|s| s.p <= 0.05 }
    @hazards4 = @survivals4.map(&:hr)
    @coefficient4 = @survivals4.map(&:b)

    ids5 = Score.expert.map(&:user_id).uniq
    @users5 = Score.expert.map(&:fname).uniq
    @survivals5 = Survival.where(user_id: ids5)
    @survivals_count5 = @survivals5.count
    @not_significant5 = @survivals5.select {|s| s.p > 0.05 }
    @significant5 = @survivals5.select {|s| s.p <= 0.05 }
    @hazards5= @survivals5.map(&:hr)
    @coefficient5 = @survivals5.map(&:b)
    ids6 = Score.novice.map(&:user_id).uniq
    @users6 = Score.novice.map(&:fname).uniq
    @survivals6 = Survival.where(user_id: ids6)
    @survivals_count6 = @survivals6.count
    @not_significant6 = @survivals6.select {|s| s.p > 0.05 }
    @significant6 = @survivals6.select {|s| s.p <= 0.05 }
    @hazards6 = @survivals4.map(&:hr)
    @coefficient6 = @survivals4.map(&:b)

    ids7 = Score.some_mdt.very_frequent_mdt.map(&:user_id).uniq
    @users7 = Score.some_mdt.very_frequent_mdt.map(&:fname).uniq
    @survivals7 = Survival.where(user_id: ids7)
    @survivals_count7 = @survivals7.count
    @not_significant7 = @survivals7.select {|s| s.p > 0.05 }
    @significant7 = @survivals7.select {|s| s.p <= 0.05 }
    @hazards7= @survivals7.map(&:hr)
    @coefficient7 = @survivals7.map(&:b)
    ids8 = Score.no_mdt.map(&:user_id).uniq
    @users8 = Score.no_mdt.map(&:fname).uniq
    @survivals8 = Survival.where(user_id: ids8)
    @survivals_count8 = @survivals8.count
    @not_significant8 = @survivals8.select {|s| s.p > 0.05 }
    @significant8 = @survivals8.select {|s| s.p <= 0.05 }
    @hazards8 = @survivals8.map(&:hr)
    @coefficient8 = @survivals8.map(&:b)


    @exp1 = Score.some_mdt.map(&:experience).sum.to_f/Score.some_mdt.count.to_f
    @exp2 = Score.no_mdt.map(&:experience).sum.to_f/Score.no_mdt.count.to_f
    @exp3 = Score.university.map(&:experience).sum.to_f/Score.university.count.to_f
    @exp4 = Score.non_university.map(&:experience).sum.to_f/Score.non_university.count.to_f
    @exp5 = Score.expert.map(&:experience).sum.to_f/Score.expert.count.to_f
    @exp6 = Score.novice.map(&:experience).sum.to_f/Score.novice.count.to_f
    @exp7 = Score.some_mdt.very_frequent_mdt.map(&:experience).sum.to_f/Score.some_mdt.very_frequent_mdt.count.to_f
    @exp8 = Score.no_mdt.map(&:experience).sum.to_f/Score.no_mdt.count.to_f

  end

  def countries_survival
    @countries = Score.all.map(&:country).uniq
    @country_array = Hash.new
    @countries.each do |c|
      ids = Score.where(country: c).map(&:user_id).uniq
      user_count = ids.count
      experience = (((Score.where(country: c).map(&:experience).sum.to_f)/60)/user_count.to_f).round(1)
      hazards = median_and_ci Survival.where(user_id: ids).map(&:hr)
      number_significant = ((Survival.where(user_id: ids).reject { |s| s.p > 0.05}.count.to_f/Survival.where(user_id: ids).count.to_f)*100).round(1)
      @country_array[c] = [user_count, experience, number_significant, hazards]
    end
    @country_array
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survival
      @survival = Survival.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def survival_params
      params.require(:survival).permit(:user_id, :name, :b, :se, :hr, :ci_lower, :ci_upper, :p)
    end
end
