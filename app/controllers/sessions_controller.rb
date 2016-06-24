class SessionsController < ApplicationController
  attr_accessor :borrower
  def index
  end

  def create
    # Login is not working
    if Borrower.where(email: params[:login][:email])
      borrower = Borrower.where(email: params[:login][:email])
      borrow_login
    else
      Lender.where(email: params[:login][:email])
      lender = Lender.where(email: params[:login][:email])
      lender_login
    end
  end

  def destroy
    reset_session
    redirect_to "/sessions"
  end

  private
  def borrow_login
    if borrower.authenticate(params[:login][:password])
      session[:user_id] = borrower.id
      redirect_to "/borrowers/#{session[:user_id]}"
    else
      flash[:danger] = "Invalid Credentials"
      redirect_to :back
    end
  end

  def lender_login
    if lender.authenticate(params[:login][:password])
      fail
      session[:user_id] = lender.id
      redirect_to "/lenders/#{session[:user_id]}"
    else
      flash[:danger] = "Invalid Credentials"
      redirect_to :back
    end
  end
end
