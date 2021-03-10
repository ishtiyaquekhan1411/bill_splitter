class BillsController < ApplicationController

  before_action :require_user

  def index

  end

  def new
    @bill = Bill.new
  end

  def create
    @bill = group.bills.build(user_id: current_user.id)
    @bill.assign_attributes(bill_params)
    if @bill.save
      flash[:notice] = t('.added_successfully')
      redirect_to group_path(id: group.id)
    else
      render :new
    end
  end

  private

  def group
    @group ||= Group.find params[:group_id]
  end

  def bill_params
    params.require(:bill).permit(:title, :amount)
  end
end