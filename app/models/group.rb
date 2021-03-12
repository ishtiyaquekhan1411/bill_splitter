# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string
#  owner_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Group < ApplicationRecord

  validates :name, presence: true, uniqueness: { scope: :owner_id }

  belongs_to :owner, class_name: 'User'
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :bills, dependent: :destroy
  has_many :splits, through: :bills

  after_create :add_owner_membership

  # Returns details of amount lent/owed by pair members of group.
  #
  # @param args [Hash]
  #   * option user_id [Integer] Logged in member id(unique identifier)
  #   * option member_id [Integer] Other Member id(unique identifier) of Group
  #
  # @return [String]
  def amount_owed_or_lent_by_member(user_id, member_id)
    user_shares = bill_shares_between_members(user_id, member_id)
    member_shares = bill_shares_between_members(member_id, user_id)
    if user_shares > member_shares
      I18n.t('general.amount_lent', amount: ((user_shares - member_shares)))
    elsif user_shares < member_shares
      I18n.t('general.amount_owes', amount: ((member_shares - user_shares)))
    else
      I18n.t('general.no_amount_shared')
    end
  end

  private

  # Add owner as a default member of group.
  #
  # @return [void]
  def add_owner_membership
  	memberships.create(group_id: id, user_id: owner_id)
  end

  # Shares of the Bill among the members of group.
  #
  # @param args [Hash]
  #   * option creditor_id [Integer]
  #   * option member_type [String]
  #   * option recipient_id [Integer]
  #
  # @return [Integer]
  def bill_shares_between_members(creditor_id, debtor_id)
    splits.joins(:bill).where(
      bill: { author_id: creditor_id },
      member_type: 'recipient',
      recipient_id: debtor_id
    ).sum(:amount)&.round(2)
  end

end
