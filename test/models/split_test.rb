# == Schema Information
#
# Table name: splits
#
#  id            :integer          not null, primary key
#  receipient_id :integer          not null
#  amount        :float
#  bill_id       :integer          not null
#  type          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "test_helper"

class SplitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
