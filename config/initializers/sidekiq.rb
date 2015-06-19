if Rails.env.try_it?
  require 'sidekiq/testing'

  Sidekiq::Testing.inline!
end

