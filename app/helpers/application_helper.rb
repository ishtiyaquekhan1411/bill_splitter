module ApplicationHelper

  def members_not_included_in_group(group_id)
    User.id_not_equals(current_user.id).pluck(:name, :id)
  end
end
