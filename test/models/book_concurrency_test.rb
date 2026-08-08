require "test_helper"

class BookConcurrencyTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  test "only one of two concurrent checkouts succeeds" do
    book = Book.create!(title: "Concurrent", author: "Test")
    count = 0
    mutex = Mutex.new

    threads = 2.times.map do
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          b = Book.find(book.id)
          mutex.synchronize { count += 1 } if b.check_out!
        end
      end
    end
    threads.each(&:join)

    assert book.reload.checked_out?
    book.destroy
    assert_equal 1, count, "Both checkouts succeeded"
  end
end