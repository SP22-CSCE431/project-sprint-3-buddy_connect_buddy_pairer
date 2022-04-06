class InterestsController < ApplicationController
  before_action :set_interest, only: %i[ show edit update destroy ]

  # GET /interests or /interests.json
  def index
    @interests = Interest.all
    @biographies = Biography.all
  end

  # GET /interests/1 or /interests/1.json
  def show
  end

  # GET /interests/new
  def new
    @interest = Interest.new
  end

  # GET /interests/1/edit
  def edit
  end

  # POST /interests or /interests.json
  def create
    temp_params = interest_params
    if temp_params[:biography].present?
      puts "here"
      temp_params.delete :biography
    end
    if temp_params[:biography] == ""
      temp_params.delete :biography
    end

    @interest = Interest.new(temp_params)
    respond_to do |format|
      if @interest.save
        if interest_params[:biography].present?
          create_bio_params = {
            :userId => current_user.studentId,
            :description => interest_params[:biography],
          }
          Biography.create(create_bio_params)
        end
        format.html { redirect_to interest_url(@interest.userId), notice: "Interest was successfully created." }
        format.json { render :show, status: :created, location: interest_path(@interest.studentId) }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @interest.errors, status: :unprocessable_entity }
        destroybio = Biography.find_by(userId: current_user.studentId)
        
      end
    end
  end

  # PATCH/PUT /interests/1 or /interests/1.json
  def update
    respond_to do |format|
      temp_params = interest_params
      temp_params.delete :biography
        create_bio_params = {
          :userId => current_user.studentId,
          :description => interest_params[:biography],
        }
        puts temp_params
        biography = Biography.find_or_create_by(userId: current_user.studentId)
        biography.update(create_bio_params)
        @interest = Interest.find_by(userId: params[:interest][:userId])
        if @interest.update(temp_params)
          format.html { redirect_to user_url(@interest.userId), notice: "Interest was successfully updated." }
          format.json { render :show, status: :ok, location: user_path(@interest.userId) }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @interest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interests/1 or /interests/1.json
  def destroy
    @interest.destroy

    respond_to do |format|
      format.html { redirect_to interests_url, notice: "Interest was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interest
      # params[:id] should be studentId
      @interest = Interest.find_by(userId: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def interest_params
      params.require(:interest).permit(:userId, :biography, :phone, :nationality, :state, :community, :numPrereqs, :scholarship, :faveMovieGenre, :numWorkExp, :usedTech, :projects, :extracurric, pastWorkExp:[], potentialRoles:[])
    end
end
