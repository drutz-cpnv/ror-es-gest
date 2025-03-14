class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]
  before_action :prepare_select_data, only: %i[ new edit create update ]

  # GET /courses or /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/calendar
  def calendar
    # Filtrer par moment (semestre) si spécifié
    if params[:moment_id].present?
      @moment = Moment.find(params[:moment_id])
      @courses = Course.where(moment_id: @moment.id)
    else
      @moment = nil
      @courses = Course.all
    end

    # Filtrer par classe si spécifié
    if params[:school_class_id].present?
      @school_class = SchoolClass.find(params[:school_class_id])
      @courses = @courses.where(school_class_id: @school_class.id)
    end

    # Récupérer tous les moments de type semestre pour le filtre
    @moments = Moment.where(moment_type: 1)

    # Récupérer les classes disponibles en fonction du moment sélectionné
    if @moment
      @school_classes = SchoolClass.where(moment_id: @moment.id)
    else
      @school_classes = SchoolClass.all
    end

    # Organiser les cours par jour de la semaine
    @courses_by_day = {
      monday: @courses.where(week_day: :monday),
      tuesday: @courses.where(week_day: :tuesday),
      wednesday: @courses.where(week_day: :wednesday),
      thursday: @courses.where(week_day: :thursday),
      friday: @courses.where(week_day: :friday)
    }
  end

  # GET /courses/1 or /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy!

    respond_to do |format|
      format.html { redirect_to courses_path, status: :see_other, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def course_params
    params.expect(course: [ :start_at, :end_at, :week_day, :school_class_id, :subject_id, :moment_id, :teacher_id ])
  end

  # Prepare data for select fields
  def prepare_select_data
    @moments = Moment.where(moment_type: [ 1, 2 ]).order(:uid) # Semestres (1) et trimestres (2)
    @subjects = Subject.all.order(:name)
    @year_moments = Moment.where(moment_type: 0).order(:uid) # Années (0)
    @school_classes = SchoolClass.none
    @teachers = Teacher.all.order(:lastname, :firstname)

    if params[:id].present? && @course&.school_class_id.present?
      @school_classes = SchoolClass.where(id: @course.school_class_id)
      Rails.logger.debug "Loaded class #{@course.school_class_id} for existing course"
    end
  end
end
