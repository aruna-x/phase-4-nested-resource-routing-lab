class ItemsController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def create
    user = User.find(params[:user_id])
    newItem = Item.create(item_params)
    user.items << newItem
    user.save
    render json: newItem, include: :user, status: :created
  end

  def show
    item = Item.find(params[:id])
    render json: item, include: :user
  end

  private

  def render_not_found_response
    render json: {error: "Not found"}, status: :not_found
  end

  def item_params
    params.permit(:name, :description, :price)
  end

end
