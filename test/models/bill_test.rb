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
require "test_helper"

class BillTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
