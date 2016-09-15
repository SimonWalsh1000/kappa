class ScoresController < ApplicationController

  include ScoresHelper

  before_action :set_score, only: [:show, :edit, :update, :destroy]

  # GET /scores
  # GET /scores.json
  def index
    @scores = Score.all
  end

  def analysis
    kappa(6, 8, "ipf")
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

  def excel
    @scores = Score.order(:id)
    respond_to do |format|
      format.html
      format.csv { send_data @scores.to_csv }
      format.xls # { send_data @products.to_csv(col_sep: "\t") }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_score
      @score = Score.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def score_params
      params.require(:score).permit(:case_id, :user_id, :dx1, :dx2, :dx3, :dx5, :dxcon2, :dxcon4, :job, :description, :experience, :fellowship, :meeting_type, :mdt_frequency, :ipf_number_cases, :imaging, :histopathology, :nsip, :ctd)
    end
end
