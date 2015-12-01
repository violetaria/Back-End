class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @categories = Category.all
    render "index.json.jbuilder", status: :ok
  end

  ## TODO Not implemented yet
  def create
    @category = current_user.categories.new(name: params[:name])
    if @category.save
      render "create.json.jbuilder", status: :created
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  ## TODO Not implemented yet
  def update

  end

  ## TODO Not implemented yet
  def destroy

  end
end
