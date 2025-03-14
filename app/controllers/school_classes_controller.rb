class SchoolClassesController < ApplicationController
  before_action :set_school_class, only: %i[ show edit update destroy ]

  # GET /school_classes or /school_classes.json
  def index
    @school_classes = SchoolClass.all
  end

  # GET /school_classes/1 or /school_classes/1.json
  def show
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
