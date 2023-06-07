require "active_record/connection_adapters/postgresql_adapter"

module DatabaseConnectionRetry
  module ClassMethods
    def new_client(*args)
      with_retries(attempts_remaining: 5, wait_time: 0.5) do
        super
      end
    end

    private

      def with_retries(attempts_remaining:, wait_time:, &block)
        attempts_remaining -= 1
        yield
      rescue
        if attempts_remaining > 0
          sleep(wait_time)
          with_retries(attempts_remaining:, wait_time:, &block)
          foo = { foo: "bar" }
        else
          raise
        end
      end
  end
end

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.singleton_class.prepend DatabaseConnectionRetry::ClassMethods
