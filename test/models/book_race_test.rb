require "test_helper"

class BookRaceTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  test "two concurrent checkouts should only allow one" do
    book = Book.create!(title: "Race", author: "Test")
    successes = Concurrent::AtomicFixnum.new(0) rescue nil
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
    assert_equal 1, count, "Both checkouts succeeded — race condition"
  end
end