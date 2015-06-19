class Users::PasswordsController < Devise::PasswordsController
  prepend_before_filter :sign_out_user

  private

  def sign_out_user
    # Since some users will be signed in automatically via links in email,
    # they may not even know their password. So, here we force a sign out
    # so the normal devise password reset controller works (since it
    # requires_no_authentication). I think this may be slightly better
    # than simply skipping the require_no_authentication filter.
    if user_signed_in?
      Devise.sign_out_all_scopes ? sign_out : sign_out(User)
      redirect_to edit_user_password_url(reset_password_token: params[:reset_password_token])
    end
  end
end

