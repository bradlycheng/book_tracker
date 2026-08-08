# class Book < ApplicationRecord
#   def check_out!
#     return false if checked_out?
#     update!(checked_out: true)
#     true
#   end

#   def check_in!
#     return false unless checked_out?
#     update!(checked_out: false)
#     true
#   end
# end
class Book < ApplicationRecord
  # Returns true if this call performed the checkout, false if the
  # book was already checked out. The lock closes the gap between
  # reading checked_out and writing it.
  def check_out!
    with_lock do
      return false if checked_out?
      update!(checked_out: true)
      true
    end
  end

  def check_in!
    with_lock do
      return false unless checked_out?
      update!(checked_out: false)
      true
    end
  end
end