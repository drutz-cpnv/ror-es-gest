class ExaminationsController < ApplicationController
  before_action :set_examination, only: %i[ show edit update destroy ]

  # GET /examinations or /examinations.json
  def index
    @examinations = Examination.all
  end

  # GET /examinations/1 or /examinations/1.json
  def show
  end

  # GET /examinations/new
  def new
    @examination = Examination.new
  end

  # GET /examinations/1/edit
  def edit
  end

  # POST /examinations or /examinations.json
  def create
    @examination = Examination.new(examination_params)

    respond_to do |format|
      if @examination.save
        format.html { redirect_to @examination, notice: "Examination was successfully created." }
        format.json { render :show, status: :created, location: @examination }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @examination.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /examinations/1 or /examinations/1.json
  def update
    respond_to do |format|
      if @examination.update(examination_params)
        format.html { redirect_to @examination, notice: "Examination was successfully updated." }
        format.json { render :show, status: :ok, location: @examination }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @examination.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /examinations/1 or /examinations/1.json
  def destroy
    @examination.destroy!

    respond_to do |format|
      format.html { redirect_to examinations_path, status: :see_other, notice: "Examination was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /examinations/1/students_with_grades
  def students_with_grades
    examination = Examination.find(params[:id])
    school_class = examination.course.school_class

    # Récupérer tous les élèves de la classe
    students = school_class.students

    # Pour chaque élève, vérifier s'il a déjà une note pour cet examen
    students_data = students.map do |student|
      grade = Grade.find_by(examination_id: examination.id, student_id: student.id)
      {
        id: student.id,
        firstname: student.firstname,
        lastname: student.lastname,
        grade: grade&.value,
      }
    end

    render json: students_data
  end

  # POST /examinations/1/save_grades
  def save_grades
    examination = Examination.find(params[:id])

    ActiveRecord::Base.transaction do
      params[:grades].each do |grade_data|
        student_id = grade_data[:student_id]
        grade_value = grade_data[:grade]

        # Ne créer/mettre à jour la note que si une valeur a été fournie
        if grade_value.present?
          # Chercher une note existante ou en créer une nouvelle
          grade = Grade.find_or_initialize_by(examination_id: examination.id, student_id: student_id)

          # Mettre à jour ou définir les valeurs
          grade.value = grade_value

          # Sauvegarder la note
          grade.save
        end
      end
    end

    head :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_examination
    @examination = Examination.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def examination_params
    params.require(:examination).permit(:title, :effective_date, :course_id)
  end
end
