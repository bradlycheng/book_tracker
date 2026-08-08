require "test_helper"

class BookLockingTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  test "with_lock prevents concurrent double checkout" do
    book = Book.create!(title: "Locked", author: "Test")
    count = 0
    mutex = Mutex.new

    threads = 2.times.map do
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          b = Book.find(book.id)
          b.with_lock do
            sleep 0.1
            unless b.checked_out?
              b.update!(checked_out: true)
              mutex.synchronize { count += 1 }
            end
          end
        end
      end
    end
    threads.each(&:join)

    book.destroy
    assert_equal 1, count
  end
end