require "active_record/connection_adapters/postgresql_adapter"

module DatabaseConnectionRetry
  def new_client(*args)
    with_retries(attempts_remaining: 5, wait_time: 0.5) do # should this config come from database.yml
      super
    end
  end

  def with_retries(attempts_remaining:, wait_time:, &attempt) # make private
    yield
  rescue
    if attempts_remaining > 0 # should this be > 1 to attempt the correct no. of times
      sleep(wait_time)

      attempts_remaining -= 1
      with_retries(attempts_remaining:, wait_time:, &attempt)
    else
      raise
    end
  end
end

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.singleton_class.prepend DatabaseConnectionRetry
