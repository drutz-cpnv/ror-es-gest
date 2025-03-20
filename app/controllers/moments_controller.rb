class MomentsController < ApplicationController
  before_action :set_moment, only: %i[ show edit update destroy ]

  # GET /moments or /moments.json
  def index
    all_moments = Moment.all.order(:start_on)
    
    # Récupérer les années
    @years = all_moments.select { |m| m.moment_type == "year" }
    
    # Pour chaque année, récupérer ses semestres
    @years.each do |year|
      year_uid = year.uid
      year.instance_variable_set(:@semesters, all_moments.select { |m| m.moment_type == "semester" && m.uid.start_with?(year_uid) })
      
      # Pour chaque semestre, récupérer ses trimestres
      year.instance_variable_get(:@semesters).each do |semester|
        semester_uid = semester.uid
        semester.instance_variable_set(:@quarters, all_moments.select { |m| m.moment_type == "quarter" && m.uid.start_with?(semester_uid) })
      end
    end
    
    # Garder aussi tous les moments pour l'affichage en tableau
    @moments = all_moments
  end

  # GET /moments/1 or /moments/1.json
  def show
  end

  # GET /moments/new
  def new
    @moment = Moment.new
  end

  # GET /moments/1/edit
  def edit
  end

  # POST /moments or /moments.json
  def create
    @moment = Moment.new(moment_params)

    respond_to do |format|
      if @moment.save
        format.html { redirect_to @moment, notice: "Moment was successfully created." }
        format.json { render :show, status: :created, location: @moment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @moment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /moments/1 or /moments/1.json
  def update
    respond_to do |format|
      if @moment.update(moment_params)
        format.html { redirect_to @moment, notice: "Moment was successfully updated." }
        format.json { render :show, status: :ok, location: @moment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @moment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /moments/1 or /moments/1.json
  def destroy
    @moment.destroy!

    respond_to do |format|
      format.html { redirect_to moments_path, status: :see_other, notice: "Moment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /moments/get_year_for_moment/:moment_id
  def get_year_for_moment
    moment_id = params[:moment_id]

    if moment_id.present?
      moment = Moment.find(moment_id)

      case moment.moment_type.to_i
      when 0 # Année
        # C'est déjà une année, on la retourne directement
        render json: { year_moment_id: moment.id, year_uid: moment.uid }
        return
      when 1, 2 # Semestre ou Trimestre
        # Extraire l'année du UID (ex: "Y2023S1" -> "Y2023")
        year_uid = moment.uid.match(/Y\d+/).to_s
        year_moment = Moment.find_by(uid: year_uid)

        if year_moment
          render json: { year_moment_id: year_moment.id, year_uid: year_moment.uid }
          return
        end
      end
    end

    # Si on arrive ici, c'est qu'on n'a pas trouvé de moment année
    render json: { error: "No year moment found" }, status: :not_found
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_moment
    @moment = Moment.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def moment_params
    params.expect(moment: [:uid, :start_on, :end_on, :moment_type])
  end
end
