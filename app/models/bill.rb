# == Schema Information
#
# Table name: bills
#
#  id         :integer          not null, primary key
#  title      :string
#  amount     :float
#  author_id  :integer          not null
#  group_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Bill < ApplicationRecord

  validates :title, :amount, presence: true

  belongs_to :author, primary_key: :id, class_name: 'User'
  belongs_to :group
  has_many :members, through: :group
  has_many :splits, dependent: :destroy

  after_create :split_bill_amount

  scope :group_id_equals, ->(group_id) { where(group_id: group_id) }

  delegate :name, to: :author, prefix: true, allow_nil: true
  delegate :name, to: :group, prefix: true, allow_nil: true

  private

  # Splits the bill amount equally to group member.
  #
  # @return [void]
  def split_bill_amount
    members.each { |member| splits.create(split_attrs(member.id)) }
  end

  # Attributes (amount, member_type and recipient_id) required for splits
  #
  # @return [Hash]
  def split_attrs(member_id)
    {
      amount: equally_shared_amount,
      member_type: is_author?(member_id) ? 'payer' : 'recipient',
      recipient_id: is_author?(member_id) ? nil : member_id
    }
  end

  # Returns amount shared for each member of group
  #
  # @return [Float]
  def equally_shared_amount
    amount / members.count
  end

  # Verifies whether member has payed bill.
  #
  # @param member_id [Integer]
  def is_author?(member_id)
    member_id == author.id
  end

end
