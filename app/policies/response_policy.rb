class ResponsePolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def save_availability?
    owner?
  end

  def save_note?
    owner?
  end

  def update
    owner?
  end

  private

  def owner?
    user.id == record.user_id
  end
end

