class MembershipsController < ApplicationController

  # Renders new form for <tt>Memberships</tt>.
  #
  # @get_params :id
  #
  # @verb GET
  #
  # @accepts HTML
  def new
    @membership = Membership.new
  end

  # Creates new <tt>Membership</tt>.
  #
  # @get_params :id
  #
  # @verb POST
  #
  # @accepts HTML
  def create
    @membership = group.memberships.build(membership_params)
    if @membership.save
      flash[:notice] = t('.member_added')
      redirect_to group_path(group.id)
    else
      render :new
    end
  end

  # Deletes <tt>Membership</tt>.
  #
  # @get_params :id
  #
  # @verb DELETE
  #
  # @accepts HTML
  def destroy
    if membership.destroy
      flash[:success] = t('.membership_destroyed')
      redirect_to group_path(group.id)
    else
      flash[:alert] = t('.not_allowed_to_destroy_group_owner')
      redirect_to group_path(group.id)
    end
  end

  private

  # Finds <tt>Membership</tt> using params id.
  #
  # @return [Membership]
  def membership
    @membership ||= Membership.find params[:id] if params[:id]
  end

  # Finds <tt>Group</tt> using params id.
  #
  # @return [Group]
  def group
    @group ||= Group.find params[:group_id] if params[:group_id]
  end

  # Only allow a list of trusted parameters through params white listing.
  def membership_params
    params.require(:membership).permit(:user_id)
  end

end