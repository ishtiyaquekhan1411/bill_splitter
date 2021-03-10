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

  def split_bill_amount
    members.each { |member| splits.create(split_attrs(member.id)) }
  end

  private

  def split_attrs(member_id)
    {
      amount: equally_shared_amount,
      member_type: is_author?(member_id) ? 'Payer' : 'Receipient',
      receipient_id: is_author?(member_id) ? nil : member_id
    }
  end

  def equally_shared_amount
    amount / members.count
  end

  def is_author?(member_id)
    member_id == author.id
  end

end
