class SessionsController < ApplicationController
  attr_accessor :borrower, :lender
  def index
  end

  def create
    lender = Lender.find_by(email: params[:email])
    borrower = Borrower.find_by(email: params[:email])

    if lender && lender.authenticate(params[:password])
      session[:user_id] = lender.id
      redirect_to "/users/#{session[:user_id]}"
    elsif borrower && borrower.authenticate(params[:password])
      session[:user_id] = borrower.id
      redirect_to "/borrowers/#{session[:user_id]}"
    else
      flash[:errors] = "Email and Password not in database"
      redirect_to :back
    end
  end

  def destroy
    reset_session
    redirect_to "/sessions"
  end
end
