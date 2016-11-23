class SurvivalsController < ApplicationController

  include ScoresHelper

  include SurvivalsHelper

  before_action :set_survival, only: [:show, :edit, :update, :destroy]

  # GET /survivals
  # GET /survivals.json
  def index
    @survivals = Survival.all
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
    ids = Score.not_fellow.map(&:user_id).uniq
    @users = Score.not_fellow.ipf_under_ten.map(&:fname).uniq
    @survivals = Survival.where(user_id: ids)
    @survivals_count = @survivals.count
    @not_significant = @survivals.select {|s| s.p.round(2) > 0.05 }
    @significant = @survivals.select {|s| s.p.round(2) <= 0.05 }
    @hazards = @survivals.select {|s| s.p.round(2) <= 0.05 }.map(&:hr)
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
