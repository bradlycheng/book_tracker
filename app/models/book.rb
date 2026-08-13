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
# class Book < ApplicationRecord
#   validates :title, presence: true
#   validates :author, presence: true

#   # Returns true if this call performed the checkout, false if the
#   # book was already checked out. The lock closes the gap between
#   # reading checked_out and writing it.
#   def check_out!
#     with_lock do
#       return false if checked_out?
#       update!(checked_out: true)
#       true
#     end
#   end

#   def check_in!
#     with_lock do
#       return false unless checked_out?
#       update!(checked_out: false)
#       true
#     end
#   end
# end
# class Book < ApplicationRecord
#   def check_out!
#     updated = self.class.where(id: id, checked_out: false)
#                         .update_all(checked_out: true, updated_at: Time.current)
#     reload if updated == 1
#     updated == 1
#   end

#   def check_in!
#     updated = self.class.where(id: id, checked_out: true)
#                         .update_all(checked_out: false, updated_at: Time.current)
#     reload if updated == 1
#     updated == 1
#   end
# end

class Book < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true

  def check_out!
    with_lock do
      return false if checked_out?
      update!(checked_out: true, due_date: 2.weeks.from_now.to_date)
      true
    end
  end

  def check_in!
    with_lock do
      return false unless checked_out?
      update!(checked_out: false, due_date: nil)
      true
    end
  end
end