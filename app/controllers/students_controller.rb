class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show generate_report ]

  # GET /students
  def index
    @students = Student.all.order(:lastname, :firstname)
  end

  # GET /students/1
  def show
    @student = Student.find(params[:id])
    @school_classes = @student.school_classes.includes(:moment).order('moments.start_on DESC')
    
    # Récupérer toutes les notes de l'étudiant
    @grades = Grade.where(student_id: @student.id)
                  .includes(examination: { course: [:subject, :moment] })
                  .order('moments.start_on DESC')
    
    # Regrouper les notes par année scolaire (moment)
    @grades_by_year = {}
    
    @grades.each do |grade|
      moment = grade.examination.course.moment
      year_uid = moment.uid.match(/Y\d+/).to_s
      
      @grades_by_year[year_uid] ||= []
      @grades_by_year[year_uid] << grade
    end
  end

  def generate_report
    moment = Moment.find(params[:moment_id])
    report_service = GradeReportService.new(@student, moment)
    pdf = report_service.generate_pdf

    send_data pdf.render,
              filename: "rapport_#{@student.lastname}_#{@student.firstname}_#{moment.uid}.pdf",
              type: "application/pdf",
              disposition: "inline"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end
end 