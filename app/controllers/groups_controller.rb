class GroupsController < ApplicationController

  before_action :require_user
  before_action :require_same_user, only: %i[destroy]

  # Renders list of <tt>Groups</tt>.
  #
  # @verb GET
  #
  # @accepts HTML
  def index
    @groups = current_user.groups.paginate(page: params[:page], per_page: 5)
  end

  # Renders new form for <tt>Group</tt>.
  #
  # @get_params :id
  #
  # @verb GET
  #
  # @accepts HTML
  def new
    @group = Group.new
  end

  # Creates new <tt>Group</tt>.
  #
  # @get_params :id
  #
  # @verb POST
  #
  # @accepts HTML
  def create
    @group = current_user.owned_group.build
    @group.assign_attributes(group_params)
    if @group.save
      redirect_to group_path(group)
    else
      render :new
    end
  end

  # Renders groups's <tt>Memberships</tt> details.
  #
  # @get_params :id
  #
  # @verb GET
  #
  # @accepts HTML
  def show
    @members = group.members.paginate(page: params[:page], per_page: 5)
  end

  # Deletes <tt>Group</tt>.
  #
  # @get_params :id
  #
  # @verb DELETE
  #
  # @accepts HTML
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

  # Finds <tt>Group</tt> using params id.
  #
  # @return [Group]
  def group
    @group ||= Group.find params[:id]
  end

  # Only allow a list of trusted parameters through params white listing.
  def group_params
    params.require(:group).permit(:name)
  end

  # Renders 'access denied' if logged in user is not an owner of group.
  def require_same_user
    if current_user != group.owner
      flash[:alert] = t('general.access_denied')
    end
  end

end
