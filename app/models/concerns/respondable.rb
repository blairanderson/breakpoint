module Respondable
  extend ActiveSupport::Concern

  included do
    has_many :responses, :as => :respondable, :dependent => :destroy
  end

  def response_for(user_id)
    responses.where(user_id: user_id).first_or_initialize
  end

  def response_token_for(user_id)
    Rails.application.message_verifier("email-response").generate([id, self.class, user_id, Time.now])
  end
end

