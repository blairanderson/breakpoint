module NotifyStateMachine
  NOTIFIED_STATES = %w[created updated notified_team]
  delegate :created?, :updated?, :notified_team?, :to => :notified_team_state

  def notified_team_state
    (notified_state || NOTIFIED_STATES.first).inquiry
  end

  def reset_notified!
    update_attributes!(:notified_state => 'updated') if notified_team?
  end

  def notified!
    update_attributes!(:notified_state => 'notified_team') if created? || updated?
  end
end

