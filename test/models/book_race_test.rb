require "test_helper"

class BookRaceTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  test "naive check-then-write permits double checkout" do
    # Documents why with_lock is necessary. Both threads read
    # checked_out = false before either writes, so both succeed.
    # See book_locking_test.rb for the same scenario with a lock.
    book = Book.create!(title: "Race", author: "Test")
    count = 0
    mutex = Mutex.new

    threads = 2.times.map do
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          b = Book.find(book.id)
          sleep 0.1
          unless b.checked_out?
            b.update!(checked_out: true)
            mutex.synchronize { count += 1 }
          end
        end
      end
    end
    threads.each(&:join)

    book.destroy
    assert_equal 2, count, "Naive read-then-write allows both checkouts to succeed"
  end
end