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
    @borrow = Borrower.all
  end

  def update
    borrow = Borrower.find(params[:id])
    lender = Lender.find(params[:lender_id])
    amount = params[:raised].to_i
    fund = History.create(amount: amount, lender: lender, borrower: borrow)

    if borrow.raised == nil
      borrow.raised = 0
    end

    # Adding and updating the borrowers record
    total =  borrow.raised
    total += amount

    if borrow.needed == nil
      borrow.needed = 0
    end
    # Deducting and updating the borrowers record
    need = borrow.needed
    need -= amount
    raised = borrow.update(raised: amount, needed: need)

    decrease = lender.money
    # If the money in the lenders account is less than the amount they want to raise, show error
    if decrease < amount
      flash[:danger] = ["Oops, You don't have enought money to loan!"]
    elsif decrease == 0
      flash[:danger] = ["Insufficient funds"]
    else
      decrease -= amount
    end
    money_decreased = lender.update(money: decrease)

    redirect_to :back
  end

  private
  def borrow_params
    params.require(:borrow).permit(:first_name, :last_name, :email, :password, :needed, :description, :purpose)
  end
end
