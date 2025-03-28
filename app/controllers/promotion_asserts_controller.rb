class PromotionAssertsController < ApplicationController
  before_action :set_promotion_assert, only: %i[ show edit update destroy ]
  before_action :prepare_select_data, only: %i[ new edit create update ]

  # GET /promotion_asserts or /promotion_asserts.json
  def index
    @promotion_asserts = PromotionAssert.all
  end

  # GET /promotion_asserts/1 or /promotion_asserts/1.json
  def show
  end

  # GET /promotion_asserts/new
  def new
    @promotion_assert = PromotionAssert.new
    @promotion_assert.function = "def is_promoted(grades)
  return true unless grades.empty?
  return true
end"
  end

  # GET /promotion_asserts/1/edit
  def edit
  end

  # POST /promotion_asserts or /promotion_asserts.json
  def create
    @promotion_assert = PromotionAssert.new(promotion_assert_params)

    respond_to do |format|
      if @promotion_assert.save
        format.html { redirect_to @promotion_assert, notice: "Promotion assert was successfully created." }
        format.json { render :show, status: :created, location: @promotion_assert }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @promotion_assert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /promotion_asserts/1 or /promotion_asserts/1.json
  def update
    respond_to do |format|
      if @promotion_assert.update(promotion_assert_params)
        format.html { redirect_to @promotion_assert, notice: "Promotion assert was successfully updated." }
        format.json { render :show, status: :ok, location: @promotion_assert }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @promotion_assert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /promotion_asserts/1 or /promotion_asserts/1.json
  def destroy
    @promotion_assert.destroy!

    respond_to do |format|
      format.html { redirect_to promotion_asserts_path, status: :see_other, notice: "Promotion assert was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_promotion_assert
    @promotion_assert = PromotionAssert.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def promotion_assert_params
    params.expect(promotion_assert: [:description, :function, :moment_id, :sector_id])
  end

  def prepare_select_data
    @moments = Moment.where("end_on > ?", Date.new).order(:uid) # Semestres (1) et trimestres (2)
    @sectors = Sector.all.order(:name)
    @year_moments = Moment.where(moment_type: 0).order(:uid) # Années (0)
    @school_classes = SchoolClass.none
    @teachers = Teacher.all.order(:lastname, :firstname)

    if params[:id].present? && @course&.school_class_id.present?
      @school_classes = SchoolClass.where(id: @course.school_class_id)
      Rails.logger.debug "Loaded class #{@course.school_class_id} for existing course"
    end
  end
end
