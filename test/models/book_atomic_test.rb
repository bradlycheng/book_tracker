require "test_helper"

class BookAtomicTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  test "conditional update prevents concurrent double checkout" do
    book = Book.create!(title: "Atomic", author: "Test")
    count = 0
    mutex = Mutex.new

    threads = 2.times.map do
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          sleep 0.1
          updated = Book.where(id: book.id, checked_out: false)
                        .update_all(checked_out: true)
          mutex.synchronize { count += 1 } if updated == 1
        end
      end
    end
    threads.each(&:join)

    book.destroy
    assert_equal 1, count
  end
end