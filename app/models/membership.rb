# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  group_id   :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Membership < ApplicationRecord

  belongs_to :group
  belongs_to :user

  validates :user_id, presence: true, uniqueness: {scope: %i[group_id user_id] }

  after_destroy :destroy_associated_bills

  def destroy_associated_bills
    # Bills and their dependent bill receipients.
  end

end
