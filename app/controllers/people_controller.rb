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

    # Gérer la création d'une nouvelle adresse si nécessaire
    if params[:address_option] == 'new' && params[:address].present?
      address = Address.new(address_params)
      if address.save
        @person.address = address
      else
        @person.valid? # Déclencher les validations pour afficher toutes les erreurs
        render :new and return
      end
    end

    @person.username =

    if @person.save
      redirect_to @person, notice: 'Person was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    # Gérer la création d'une nouvelle adresse si nécessaire
    if params[:address_option] == 'new' && params[:address].present?
      address = Address.new(address_params)
      if address.save
        @person.address = address
      else
        @person.valid? # Déclencher les validations pour afficher toutes les erreurs
        render :edit and return
      end
    end

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
      params.require(:person).permit(:email, :password, :password_confirmation, :type, 
                                     :address_id, :status_id, :username, :lastname, 
                                     :firstname, :phone_number, :iban)
    end

    # Paramètres pour la création d'une nouvelle adresse
    def address_params
      params.require(:address).permit(:zip, :town, :street, :number)
    end

    def ensure_dean
      unless current_person.dean?
        redirect_to root_path, alert: 'Only deans can access this area.'
      end
    end
end
