class PeopleController < ApplicationController
  before_action :authenticate_person!
  before_action :ensure_dean
  before_action :set_person, only: %i[ show edit update destroy ]

  # GET /people or /people.json
  def index
    @people = Person.all
  end

  # GET /people/1 or /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people or /people.json
  def create
    @person = Person.new(person_params)

    if @person.save
      redirect_to @person, notice: 'Person was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    if @person.update(person_params)
      redirect_to @person, notice: 'Person was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /people/1 or /people/1.json
  def destroy
    @person.destroy
    redirect_to people_url, notice: 'Person was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(:email, :password, :password_confirmation, :type, :address_id, :status_id)
    end

    def ensure_dean
      unless current_person.dean?
        redirect_to root_path, alert: 'Only deans can access this area.'
      end
    end
end
