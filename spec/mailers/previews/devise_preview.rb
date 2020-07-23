# previews: http://localhost:3000/rails/mailers/devise/reset_password_instructions
class DevisePreview < ActionMailer::Preview
  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(User.new, Devise.friendly_token[0, 20])
  end
end
