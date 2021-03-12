# == Schema Information
#
# Table name: splits
#
#  id            :integer          not null, primary key
#  recipient_id :integer          not null
#  amount        :float
#  bill_id       :integer          not null
#  member_type          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Split < ApplicationRecord

  validates :bill_id, presence: true

  belongs_to :bill
  belongs_to :recipient,
    class_name: 'User',
    foreign_key: :recipient_id,
    primary_key: :id,
    optional: true
  has_one :author, through: :bill

  after_destroy :update_associated_bill_amount

  delegate :name, to: :recipient, prefix: :debtor, allow_nil: true

  private

  # Updates bill amount with difference in shares.
  #
  # @return [void]
  def update_associated_bill_amount
    bill.update_attribute(:amount, bill.amount - amount)
  end

end
