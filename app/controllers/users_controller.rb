class UsersController < ApplicationController
  def index
    @money = monies
  end

  def create
    lender = Lender.new(lender_params)
    if lender.save
      session[:user_id] = lender.id
      redirect_to "/users/#{session[:user_id]}"
    else
      flash[:errors] = lender.errors.full_messages
      redirect_to :back
    end
  end

  def show
    @lender = Lender.find(params[:id])
    @help = Borrower.all
    @money = monies
  end

  private
  def monies
    money = [100, 200, 300, 400, 500]
  end

  def lender_params
    params.require(:register).permit(:first_name, :last_name, :email, :password, :money)
  end
end
