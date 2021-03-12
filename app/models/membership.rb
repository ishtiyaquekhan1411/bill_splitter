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

  before_destroy :validate_owner_of_group
  after_destroy :destroy_associated_bill_splits

  private

  def validate_owner_of_group
    if user == group.owner
      errors.add(:base, I18n.t('memberships.destroy.not_allowed_to_destroy_group_owner'))
    end
  end

  # Deletes associated bill shares once membership is removed from the group.
  #
  # @return [void]
  def destroy_associated_bill_splits
    group.splits.where(recipient_id: user_id).destroy_all
  end

end
