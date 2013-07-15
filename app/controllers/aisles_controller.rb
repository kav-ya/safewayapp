class AislesController < ApplicationController
  def index
      @aisles = Aisle.all
  end

  def view
      @aisle = Aisle.find(params[:id])
      @products = @aisle.products
  end
end
