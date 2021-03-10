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

  def add_owner_membership
  	memberships.create(group_id: id, user_id: owner_id)
  end

end
