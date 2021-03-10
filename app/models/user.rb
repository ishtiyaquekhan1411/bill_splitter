# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  name            :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :name, presence: true,
   uniqueness: { case_sensitive: false },
    length: { minimum: 3, maximum: 25 }

  validates :email, presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: VALID_EMAIL_REGEX },
    length: { maximum: 105 }

  has_secure_password

  before_save { self.email = email.downcase }

  has_many :owned_group, foreign_key: :owner_id, class_name: 'Group'
  has_many :memberships
  has_many :groups, through: :memberships, source: :group
  has_many :author_bills, foreign_key: :author_id, class_name: 'Bill'
  has_many :splits, through: :author_bills, class_name: 'Bill'

  scope :id_not_equals, ->(id) { where.not(id: id) }

end
