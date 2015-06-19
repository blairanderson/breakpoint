class AddTeamMembers
  include ActiveModel::Model

  attr_accessor :users

  validate :valid_users

  def self.users_from_emails(team, emails)
    # remove existing team_members
    emails = emails - team.users.pluck(:email)
    existing_users = User.where(email: emails)
    new_emails = emails - existing_users.collect(&:email)
    new_users = new_emails.map do |email|
      User.new(name:     email.split('@').first,
               email:    email,
               password: SecureRandom.uuid)
    end

    new(users: new_users + existing_users)
  end

  def users_attributes=(attributes)
    @new_users ||= []
    emails = attributes.values.collect { |u| u[:email] }
    @existing_users = User.where(email: emails)
    existing_emails = @existing_users.collect(&:email)
    attributes.each do |i, user_params|
      next if existing_emails.include?(user_params[:email])
      @new_users.push(User.new(user_params.merge({ password: SecureRandom.uuid })))
    end
    @users = @new_users + @existing_users
  end

  def valid_users
    @new_users.each do |user|
      unless user.valid?
        errors.add(user.email, user.errors.full_messages)
      end
    end
  end

  def save(team)
    if valid?
      @new_users.each do |user|
        user.password = SecureRandom.uuid
        user.save
      end
      team.users.push(@new_users + @existing_users)
      true
    else
      false
    end
  end
end

