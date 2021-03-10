class MembershipsController < ApplicationController

  def new
    @membership = Membership.new
  end

  def create
    @membership = group.memberships.build(membership_params)
    if @membership.save
      flash[:notice] = t('.member_added')
      redirect_to group_path(group.id)
    else
      render :new
    end
  end

  def destroy
    ap membership.user
    ap group.owner
    if membership.user != group.owner
      membership.destroy
      flash[:success] = t('.membership_destroyed')
      redirect_to group_path(group.id)
    else
      flash[:alert] = t('.not_allowed_to_destroy_group_owner')
      redirect_to group_path(group.id)
    end
  end

  private

  def membership
    @membership ||= Membership.find params[:id] if params[:id]
  end

  def group
    @group ||= Group.find params[:group_id] if params[:group_id]
  end

  def membership_params
    params.require(:membership).permit(:user_id)
  end

end