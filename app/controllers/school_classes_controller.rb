class SchoolClassesController < ApplicationController
  before_action :set_school_class, only: %i[ show edit update destroy ]

  # GET /school_classes or /school_classes.json
  def index
    @school_classes = SchoolClass.all
  end

  # GET /school_classes/new
  def new
    @school_class = SchoolClass.new
  end

  # GET /school_classes/1/edit
  def edit
  end

  # POST /school_classes or /school_classes.json
  def create
    @school_class = SchoolClass.new(school_class_params)

    respond_to do |format|
      if @school_class.save
        format.html { redirect_to @school_class, notice: "School class was successfully created." }
        format.json { render :show, status: :created, location: @school_class }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @school_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /school_classes/1 or /school_classes/1.json
  def update
    respond_to do |format|
      if @school_class.update(school_class_params)
        format.html { redirect_to @school_class, notice: "School class was successfully updated." }
        format.json { render :show, status: :ok, location: @school_class }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @school_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /school_classes/1 or /school_classes/1.json
  def destroy
    @school_class.destroy!

    respond_to do |format|
      format.html { redirect_to school_classes_path, status: :see_other, notice: "School class was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /school_classes/by_year_moment/:year_moment_id
  def by_year_moment
    year_moment_id = params[:year_moment_id]

    if year_moment_id.present?
      @school_classes = SchoolClass.where(moment_id: year_moment_id).order(:name)
    else
      @school_classes = SchoolClass.none
    end

    render json: @school_classes.map { |sc| { id: sc.id, name: sc.name } }
  end

  # GET /school_classes/by_moment/:moment_id
  def by_moment
    moment_id = params[:moment_id]
    Rails.logger.debug "by_moment called with moment_id: #{moment_id}"

    begin
      if moment_id.present?
        moment = Moment.find(moment_id)
        Rails.logger.debug "Found moment: #{moment.uid} (type: #{moment.moment_type}, id: #{moment.moment_type.to_sym})"

        case moment.moment_type.to_sym
        when :year # Année
          # Si c'est une année, on récupère directement les classes associées
          @school_classes = SchoolClass.where(moment_id: moment.id).order(:name)
          Rails.logger.debug "Year moment, found #{@school_classes.count} classes"
        when :semester, :quarter # Semestre ou Trimestre
          # Si c'est un semestre ou un trimestre, on récupère l'année correspondante
          year_uid = moment.uid.match(/Y\d+/).to_s
          Rails.logger.debug "Extracted year_uid: #{year_uid}"
          year_moment = Moment.find_by(uid: year_uid)

          if year_moment
            Rails.logger.debug "Found year_moment: #{year_moment.uid} (id: #{year_moment.id})"
            @school_classes = SchoolClass.where(moment_id: year_moment.id).order(:name)
            Rails.logger.debug "Found #{@school_classes.count} classes for year moment"
          else
            Rails.logger.debug "No year moment found for uid: #{year_uid}"
            @school_classes = SchoolClass.none
          end
        else
          Rails.logger.debug "Unknown moment type: #{moment.moment_type}"
          @school_classes = SchoolClass.none
        end
      else
        Rails.logger.debug "No moment_id provided"
        @school_classes = SchoolClass.none
      end

      result = @school_classes.map { |sc| { id: sc.id, name: sc.name } }
      Rails.logger.debug "Returning #{result.length} classes: #{result.inspect}"
      render json: result
    rescue => e
      Rails.logger.error "Error in by_moment: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  # GET /school_classes/:id/details
  def get_class_details
    school_class_id = params[:id]
    Rails.logger.debug "get_class_details called with id: #{school_class_id}"

    begin
      school_class = SchoolClass.find(school_class_id)
      render json: { id: school_class.id, name: school_class.name, moment_id: school_class.moment_id }
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error "School class not found with id: #{school_class_id}"
      render json: { error: "School class not found" }, status: :not_found
    end
  end

  # GET /school_classes/:id
  def show
    @school_class = SchoolClass.find(params[:id])
    @students = @school_class.students.order(:lastname, :firstname)
    @courses = @school_class.courses.includes(:subject, :teacher, :moment)
    @teachers = Teacher.joins(:courses).where(courses: { school_class_id: @school_class.id }).distinct
    @moments = Moment.all
    @subjects = Subject.joins(:courses).where(courses: { school_class_id: @school_class.id }).distinct

    # Récupérer toutes les évaluations pour cette classe
    course_ids = @courses.pluck(:id)
    @examinations = Examination.where(course_id: course_ids)
                               .includes(course: [:subject, :teacher, :moment], grades: [:student])
                               .order(effective_date: :desc)

    # Regrouper les examens par étudiant et par matière pour le bulletin
    @grades_by_student = {}
    @students.each do |student|
      @grades_by_student[student.id] = {}
      @school_class.courses.each do |course|
        examinations = course.examinations
        grades = Grade.where(examination_id: examinations.pluck(:id), student_id: student.id)

        if grades.any?
          @grades_by_student[student.id][course.subject_id] = {
            grades: grades,
            average: grades.average(:value).to_f.round(2)
          }
        end
      end
    end
  end

  # GET /school_classes/:id/students
  def students
    @school_class = SchoolClass.find(params[:id])
    @students = @school_class.students.order(:lastname, :firstname)

    respond_to do |format|
      format.html { render partial: 'students', locals: { students: @students } }
      format.json { render json: @students }
    end
  end

  # GET /school_classes/:id/courses
  def courses
    @school_class = SchoolClass.find(params[:id])
    moment_id = params[:moment_id]

    @courses = @school_class.courses
    @courses = @courses.where(moment_id: moment_id) if moment_id.present?
    @courses = @courses.includes(:subject, :teacher)

    respond_to do |format|
      format.html { render partial: 'courses', locals: { courses: @courses } }
      format.json { render json: @courses }
    end
  end

  # GET /school_classes/:id/grades
  def grades
    @school_class = SchoolClass.find(params[:id])
    @students = @school_class.students.order(:lastname, :firstname)
    @subjects = Subject.joins(:courses).where(courses: { school_class_id: @school_class.id }).distinct

    # Regrouper les examens par étudiant et par matière pour le bulletin
    @grades_by_student = {}
    @students.each do |student|
      @grades_by_student[student.id] = {}
      @school_class.courses.each do |course|
        examinations = course.examinations
        grades = Grade.where(examination_id: examinations.pluck(:id), student_id: student.id)

        if grades.any?
          @grades_by_student[student.id][course.subject_id] = {
            grades: grades,
            average: grades.average(:value).to_f.round(2)
          }
        end
      end
    end

    respond_to do |format|
      format.html { render partial: 'grades', locals: { students: @students, subjects: @subjects, grades_by_student: @grades_by_student } }
      format.json { render json: @grades_by_student }
    end
  end

  # GET /school_classes/:id/teachers
  def teachers
    @school_class = SchoolClass.find(params[:id])
    @teachers = Teacher.joins(:courses).where(courses: { school_class_id: @school_class.id }).distinct

    respond_to do |format|
      format.html { render partial: 'teachers', locals: { teachers: @teachers } }
      format.json { render json: @teachers }
    end
  end

  # POST /school_classes/:id/add_student
  def add_student
    @school_class = SchoolClass.find(params[:id])

    # If an existing student ID is provided
    if params[:student_id].present?
      student = Student.find(params[:student_id])
    # Otherwise, create a new student
    elsif params[:firstname].present? && params[:lastname].present?
      student = Student.new(
        firstname: params[:firstname],
        lastname: params[:lastname],
        email: params[:email]
      )
      unless student.save
        flash[:alert] = "Error creating student: #{student.errors.full_messages.join(', ')}"
        redirect_to @school_class and return
      end
    else
      flash[:alert] = "Please select an existing student or fill in the required fields to create a new one."
      redirect_to @school_class and return
    end

    # Associate the student with the class
    unless @school_class.students.include?(student)
      @school_class.students << student
      flash[:notice] = "The student has been successfully added to the class."
    else
      flash[:alert] = "This student is already in the class."
    end

    redirect_to @school_class
  end

  # POST /school_classes/:id/add_course
  def add_course
    @school_class = SchoolClass.find(params[:id])

    # Vérifier que tous les paramètres nécessaires sont présents
    if params[:subject_id].blank? || params[:teacher_id].blank? || params[:moment_id].blank? ||
      params[:week_day].blank? || params[:start_time].blank? || params[:end_time].blank?
      flash[:alert] = "Tous les champs sont requis pour ajouter un cours."
      redirect_to @school_class and return
    end

    # Créer le cours
    course = Course.new(
      school_class_id: @school_class.id,
      subject_id: params[:subject_id],
      teacher_id: params[:teacher_id],
      moment_id: params[:moment_id],
      week_day: params[:week_day],
      start_time: params[:start_time],
      end_time: params[:end_time]
    )

    if course.save
      flash[:notice] = "Le cours a été ajouté avec succès."
    else
      flash[:alert] = "Erreur lors de l'ajout du cours: #{course.errors.full_messages.join(', ')}"
    end

    redirect_to @school_class
  end

  # POST /school_classes/:id/add_examination
  def add_examination
    @school_class = SchoolClass.find(params[:id])

    # Vérifier que tous les paramètres nécessaires sont présents
    if params[:course_id].blank? || params[:title].blank? || params[:effective_date].blank?
      flash[:alert] = "Le cours, le titre et la date sont requis pour ajouter une évaluation."
      redirect_to @school_class and return
    end

    # Créer l'évaluation
    examination = Examination.new(
      course_id: params[:course_id],
      title: params[:title],
      effective_date: params[:effective_date],
    )

    if examination.save
      flash[:notice] = "L'évaluation a été ajoutée avec succès."
    else
      flash[:alert] = "Erreur lors de l'ajout de l'évaluation: #{examination.errors.full_messages.join(', ')}"
    end

    redirect_to @school_class
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_school_class
    @school_class = SchoolClass.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to school_classes_path, alert: "School class not found" }
      format.json { render json: { error: "School class not found" }, status: :not_found }
    end
  end

  # Only allow a list of trusted parameters through.
  def school_class_params
    params.expect(school_class: [:uid, :name, :moment_id, :room_id, :master_id, :sector_id])
  end
end
