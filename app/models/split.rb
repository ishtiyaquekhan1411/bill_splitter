# == Schema Information
#
# Table name: splits
#
#  id            :integer          not null, primary key
#  receipient_id :integer          not null
#  amount        :float
#  bill_id       :integer          not null
#  member_type          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Split < ApplicationRecord

  validates :bill_id, presence: true

  has_one :author, through: :bill
  belongs_to :receipient,
    class_name: 'User',
    foreign_key: :receipient_id,
    primary_key: :id,
    optional: true
  belongs_to :bill

end
