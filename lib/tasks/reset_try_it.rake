namespace :breakpointapp do  
  task :reset_try_it => :environment do
    if Rails.env.try_it?
      ActiveRecord::Base.connection.execute('truncate responses')
      ActiveRecord::Base.connection.execute('truncate match_lineups')
      ActiveRecord::Base.connection.execute('truncate match_players')
      ActiveRecord::Base.connection.execute('truncate match_sets')
      ActiveRecord::Base.connection.execute('truncate matches')
      ActiveRecord::Base.connection.execute('truncate practices')
      ActiveRecord::Base.connection.execute('truncate schema_migrations')
      ActiveRecord::Base.connection.execute('truncate team_members')
      ActiveRecord::Base.connection.execute('truncate teams')
      ActiveRecord::Base.connection.execute('truncate users')
      ActiveRecord::Base.connection.execute('truncate versions')
      Rake::Task["db:schema:load"].invoke
      Rake::Task["db:seed"].invoke
    end
  end
end

