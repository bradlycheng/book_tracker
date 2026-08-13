require "test_helper"

class BookRaceTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  # Documents why Book#check_out! doesn't need a pessimistic lock: the
  # partial unique index on checkouts(book_id) WHERE returned_at IS NULL
  # makes a double-checkout impossible at the database level, no matter how
  # naively the application code checks first. This deliberately does NOT
  # call check_out! - it inlines the same naive check-then-write pattern
  # that used to race against a boolean column, to prove the index (not
  # careful app code) is what's actually holding the line.
  # See book_concurrency_test.rb for the same scenario using the real method.
  test "naive check-then-write still can't double-checkout, because the index rejects it" do
    book = Book.create!(title: "Race", author: "Test")
    successes = 0
    conflicts = 0
    mutex = Mutex.new

    threads = 2.times.map do
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          b = Book.find(book.id)
          sleep 0.1
          unless b.checked_out?
            begin
              b.checkouts.create!(checked_out_at: Time.current)
              mutex.synchronize { successes += 1 }
            rescue ActiveRecord::RecordNotUnique
              mutex.synchronize { conflicts += 1 }
            end
          end
        end
      end
    end
    threads.each(&:join)

    book.destroy
    assert_equal 1, successes, "Both threads read false before either wrote, but only one insert can win"
    assert_equal 1, conflicts, "The second insert should be rejected by the partial unique index"
  end
end
