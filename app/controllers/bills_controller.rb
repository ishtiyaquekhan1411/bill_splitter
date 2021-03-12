class BillsController < ApplicationController

  before_action :require_user

  # Renders list of <tt>Bills</tt>.
  #
  # @verb GET
  #
  # @accepts HTML
  def index
    @bills = Bill.includes(:splits).paginate(page: params[:page], per_page: 5)
  end

  # Renders new form for <tt>Bill</tt>.
  #
  # @get_params :id
  #
  # @verb GET
  #
  # @accepts HTML
  def new
    @bill = Bill.new
  end

  # Creates new <tt>Bill</tt>.
  #
  # @get_params :id
  #
  # @verb POST
  #
  # @accepts HTML
  def create
    @bill = group.bills.build(author_id: current_user.id)
    @bill.assign_attributes(bill_params)
    if @bill.save
      flash[:notice] = t('.added_successfully')
      redirect_to group_path(id: group.id)
    else
      render :new
    end
  end

  private

  # Finds <tt>Group</tt> using params id.
  #
  # @return [Group]
  def group
    @group ||= Group.find params[:group_id]
  end

  # Only allow a list of trusted parameters through params white listing.
  def bill_params
    params.require(:bill).permit(:title, :amount)
  end

end