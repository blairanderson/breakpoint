namespace :breakpointapp do
  desc 'Prints emails for sample users to the console'
  task :user_info => [:environment] do
    unless Rails.env.development?
      raise 'This task can only be run in the development environment'
    end
    puts User.pluck(:email)
  end
end