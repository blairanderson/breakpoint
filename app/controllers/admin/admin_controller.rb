class Admin::AdminController < ApplicationController
  before_action :authorize_admin

  private

  def authorize_admin
    unless AdminPolicy.new(current_user).admin?
      raise Pundit::NotAuthorizedError
    end
  end
end

