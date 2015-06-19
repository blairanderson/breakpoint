class TryItSeeds
  def seed!
    create_captain
    create_team_members
    create_practices_and_matches
    create_availabilities
  end

  def find_captain
    @captain ||= User.joins(:team_members).where("team_members.role = 'captain'").first
  end

  def captain
    if find_captain.nil?
      seed!
      find_captain
    else
      find_captain
    end
  end

  def find_member
    User.joins(:team_members).where("team_members.role = 'member'").first
  end

  def member
    if find_member.nil?
      seed!
      find_member
    else
      find_member
    end
  end

  def members
    @members ||= 0.upto(8).map do
      User.create!(email: Faker::Internet.email,
                   first_name: Faker::Name.first_name,
                   last_name: Faker::Name.last_name,
                   phone_number: Faker::PhoneNumber.phone_number,
                   password: SecureRandom.uuid)
    end
  end

  def find_team
    @team ||= Team.first
  end

  def team_names
    [
      "Pebble Beach Men's 3.0",
      "Indian Wells Women's 3.0",
      "Napa Mixed 7.0",
      "Key Biscayne Men's 4.0",
      "Sun Valley Women's 3.5",
    ]
  end

  def team
    find_team || Team.create!(name: team_names.sample,
                              email: Faker::Internet.domain_word,
                              singles_matches: 2,
                              doubles_matches: 3,
                              date: 1.week.from_now)
  end

  def create_captain
    @captain = User.create!(email: Faker::Internet.email,
                           first_name: Faker::Name.first_name,
                           last_name: Faker::Name.last_name,
                           phone_number: Faker::PhoneNumber.phone_number,
                           password: SecureRandom.uuid)
    team.team_members.create!(user: captain, role: TeamMember::ROLES.first, welcome_email_sent_at: Time.now)
    captain
  end

  def create_team_members
    members.each { |m| team.team_members.create!(user: m, role: TeamMember::ROLES.last) }
  end

  def create_practices_and_matches
    ActsAsTenant.with_tenant(team) do
      0.upto(8) do |i|
        p_address = "#{Faker::Address.street_address}\n#{Faker::Address.city}, #{Faker::Address.state_abbr} #{Faker::Address.zip}"
        m_address = "#{Faker::Address.street_address}\n#{Faker::Address.city}, #{Faker::Address.state_abbr} #{Faker::Address.zip}"
        Practice.create!(team: team, date: (i + 2).send(:weeks).from_now, location: p_address, comment: Faker::Lorem.sentence(10))
        Match.create!(team: team, date: (i + 3).send(:weeks).from_now, location: m_address, comment: Faker::Lorem.sentence(10))
      end
    end
  end

  def create_availabilities
    ActsAsTenant.with_tenant(team) do
      team.users.each do |user|
        Match.all.each do |match|
          state = ["yes", "maybe", "no", "no_response"].sample
          match_availability = match.response_for(user.id)
          match_availability.state = state
          match_availability.save
        end

        Practice.all.each do |practice|
          next if [1,2,3,4].sample == 3
          state = ["yes", "maybe", "no", "no_response"].sample
          practice.responses.create!(team: team, user: user, state: state)
        end
      end
    end
  end
end

