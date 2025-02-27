class StudentClassesController < ApplicationController
  before_action :set_student_class, only: %i[ show edit update destroy ]

  # GET /student_classes or /student_classes.json
  def index
    @student_classes = StudentClass.all
  end

  # GET /student_classes/1 or /student_classes/1.json
  def show
  end

  # GET /student_classes/new
  def new
    @student_class = StudentClass.new
  end

  # GET /student_classes/1/edit
  def edit
  end

  # POST /student_classes or /student_classes.json
  def create
    @student_class = StudentClass.new(student_class_params)

    respond_to do |format|
      if @student_class.save
        format.html { redirect_to @student_class, notice: "Student class was successfully created." }
        format.json { render :show, status: :created, location: @student_class }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /student_classes/1 or /student_classes/1.json
  def update
    respond_to do |format|
      if @student_class.update(student_class_params)
        format.html { redirect_to @student_class, notice: "Student class was successfully updated." }
        format.json { render :show, status: :ok, location: @student_class }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_classes/1 or /student_classes/1.json
  def destroy
    @student_class.destroy!

    respond_to do |format|
      format.html { redirect_to student_classes_path, status: :see_other, notice: "Student class was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_class
      @student_class = StudentClass.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def student_class_params
      params.expect(student_class: [ :student_id, :school_class_id ])
    end
end
