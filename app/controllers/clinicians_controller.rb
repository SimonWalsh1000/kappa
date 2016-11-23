class CliniciansController < ApplicationController
  before_action :set_clinician, only: [:show, :edit, :update, :destroy]

  # GET /clinicians
  # GET /clinicians.json
  def index
    @clinicians = Clinician.all
  end

  def breakdown
    @scorers = Score.novice.map(&:email)
    @experts = Score.expert.map(&:email)
    @emails = Clinician.all.map(&:email).reject{|e| @experts.include?(e)}
    @participants = Clinician.select {|u| @scorers.include?(u.email)}.map(&:email).uniq
    @invited_clinicians = Clinician.invited
    @ild_novices = Clinician.ild_specialist.select {|u| @scorers.include?(u.email)}.map(&:email).uniq
    @ild_invited_novices = Clinician.invited.ild_specialist.select {|u| @scorers.include?(u.email)}.map(&:email).uniq
    @ild_novices_percentage = (@ild_novices.count.to_f/ @scorers.count.to_f) * 100
    @not_ild_novices = Clinician.not_ild_specialist.select {|u| @scorers.include?(u.email)}.map(&:email).uniq




  end

  # GET /clinicians/1
  # GET /clinicians/1.json
  def show
  end

  # GET /clinicians/new
  def new
    @clinician = Clinician.new
  end

  # GET /clinicians/1/edit
  def edit
  end

  # POST /clinicians
  # POST /clinicians.json
  def create
    @clinician = Clinician.new(clinician_params)

    respond_to do |format|
      if @clinician.save
        format.html { redirect_to @clinician, notice: 'Clinician was successfully created.' }
        format.json { render :show, status: :created, location: @clinician }
      else
        format.html { render :new }
        format.json { render json: @clinician.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clinicians/1
  # PATCH/PUT /clinicians/1.json
  def update
    respond_to do |format|
      if @clinician.update(clinician_params)
        format.html { redirect_to @clinician, notice: 'Clinician was successfully updated.' }
        format.json { render :show, status: :ok, location: @clinician }
      else
        format.html { render :edit }
        format.json { render json: @clinician.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clinicians/1
  # DELETE /clinicians/1.json
  def destroy
    @clinician.destroy
    respond_to do |format|
      format.html { redirect_to clinicians_url, notice: 'Clinician was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload
    render 'uploader'
  end

  def import
    Clinician.import(params[:file])
    redirect_to clinicians_path, notice: "Clinicians imported."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clinician
      @clinician = Clinician.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clinician_params
      params.require(:clinician).permit(:name, :email, :country, :society, :general, :specialty)
    end
end
