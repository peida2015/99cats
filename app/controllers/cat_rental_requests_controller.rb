class CatRentalRequestsController < ApplicationController
  def new
    @request = CatRentalRequest.new
    @cats = Cat.all
  end

  def create
    @request = CatRentalRequest.new(request_params)
    @cats = Cat.all
    if @request.save
      redirect_to cats_url
    else
      render :new
    end
  end

  def approve
    request = CatRentalRequest.find(params[:id])
    request.approve!
    redirect_to cat_url(request.cat)
  end

  def deny
    request = CatRentalRequest.find(params[:id])
    request.deny!
    redirect_to cat_url(request.cat)
  end

  private
  def request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end
end
