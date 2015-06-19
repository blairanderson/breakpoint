module SidekiqTimezone
  class Server
    def call(worker_class, msg, queue)
      if ActsAsTenant.current_tenant.present?
        Time.use_zone(ActsAsTenant.current_tenant.time_zone) do
          yield
        end
      else
        yield
      end
    end
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add SidekiqTimezone::Server
  end
end

