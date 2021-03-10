class GroupsController < ApplicationController

  before_action :require_user
  before_action :require_same_user, only: %i[show destroy]

  def index
    @groups = current_user.groups.paginate(page: params[:page], per_page: 5)
  end

  def new
    @group = Group.new
  end

  def create
    @group = current_user.owned_group.build
    @group.assign_attributes(group_params)
    if @group.save
      redirect_to group_path(group)
    else
      render :new
    end
  end

  def show
    @members = group.members.paginate(page: params[:page], per_page: 2)
  end

  def destroy
    if group.destroy
      flash[:success] = t('.group_destroyed')
      redirect_to groups_path
    else
      flash.now[:alert] = t('.unable_to_delete')
      render :index
    end
  end

  private

  def group
    @group ||= Group.find params[:id]
  end

  def group_params
    params.require(:group).permit(:name)
  end

  def require_same_user
    if current_user != group.owner
      flash[:alert] = t('general.access_denied')
    end
  end

end
