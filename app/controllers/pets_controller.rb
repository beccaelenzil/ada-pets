KEYS = ["id", "name", "age", "human"].sort

class PetsController < ApplicationController
  #protect_from_forgery with: :null_session

  def index
    pets = Pet.all.as_json(only: KEYS)
    render json: pets, status: :ok
  end

  def show
    pet_id = params[:id]
    pet = Pet.find_by(id: pet_id)
    if pet.nil?
      render json: {}, status: :not_found
    else
      render json: pet.as_json(only: KEYS), status: :ok
    end
  end

  def create
    pet = Pet.new(pet_params)

    if pet.save
      render json: pet.as_json(only: [:id]), status: :created
      return
    else
      render json: {ok: false, errors: pet.errors.messages}, status: :bad_request
      return
    end

  end

  private

  def pet_params
    params.require(:pet).permit(:name, :age, :human)
  end

end
