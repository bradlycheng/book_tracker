require "test_helper"

class BookRaceTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  # Documents the bug that Book#check_out! guards against.
  # Deliberately does NOT call check_out! — it inlines the unguarded
  # read-then-write so the failure mode is visible.
  # See book_concurrency_test.rb for the same scenario using the real method.
  test "naive check-then-write permits double checkout" do
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
    assert_equal 2, count, "Both threads read false before either wrote"
  end
end