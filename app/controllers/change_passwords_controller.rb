class ChangePasswordsController < ApplicationController
  def send_reset
    User.find(current_user.id).send_reset_password_instructions
    Devise.sign_out_all_scopes ? sign_out : sign_out(User)
    redirect_to root_url, notice: I18n.t("devise.passwords.send_instructions")
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    if @user.update_with_password(permitted_params.password)
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to root_url, notice: "Your password was changed successfully."
    else
      render "edit"
    end
  end
end

