class SplitMemberType < EnumerateIt::Base
  associate_values(
    :payer,
    :receipient
  )
end
