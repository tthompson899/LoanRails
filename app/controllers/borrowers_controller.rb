class BorrowersController < ApplicationController
  def create
    borrow = Borrower.new(borrow_params)
    if borrow.save && borrow.authenticate(params[:borrow][:password])
      session[:user_id] = borrow.id
      redirect_to "/borrowers/#{session[:user_id]}"
    else
      flash[:errors] = borrow.errors.full_messages
      redirect_to :back
    end
  end

  def show
    @borrower = Borrower.find(params[:id])
    @lend = Lender.joins(:histories).select("lenders.first_name, lenders.last_name, lenders.email").select("histories.amount, histories.borrower_id, histories.lender_id")
  end

  def update
    borrow = Borrower.find(params[:id])
    lender = Lender.find(params[:lender_id])
    amount = params[:raised].to_i

    # If the money in the lenders account is less than the amount they want to raise, show error
    decrease = lender.money
    if decrease < amount
      flash[:danger] = ["Oops, You don't have enought money to loan!"]
      redirect_to :back and return
    else
      decrease -= amount
      money_decreased = lender.update(money: decrease)
    end

    if borrow.needed == nil
      borrow.needed = 0
    end

    if borrow.raised == nil
      borrow.raised = 0
    end

    # Adding and updating the borrowers record
    #Deducting and updating the borrowers record
    need = borrow.needed
    total =  borrow.raised
    total += amount
    need -= amount
    raised = borrow.update(raised: total, needed: need)

    fund = History.create(amount: amount, lender: lender, borrower: borrow)
    redirect_to :back
  end

  private
  def borrow_params
    params.require(:borrow).permit(:first_name, :last_name, :email, :password, :password_confirmation,:needed, :description, :purpose)
  end
end
