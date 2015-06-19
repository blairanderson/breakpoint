namespace :breakpointapp do  
  task :reset_passwords => :environment do
    if Rails.env.development?
      password = ::BCrypt::Password.create("password", cost: User.stretches)
      User.update_all(encrypted_password: password)
    end
  end
end

