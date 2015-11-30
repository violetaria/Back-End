class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @categories = Category.all
    render "index.json.jbuilder"
  end

  ## TODO Not implemented yet
  def create
    @category = Category.new(name: params[:name])
    if @category.save
      render "create.json.jbuilder", status: :created
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update

  end

  def destroy

  end
end
