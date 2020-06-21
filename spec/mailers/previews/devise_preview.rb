# previews: http://localhost:3000/rails/mailers/devise/confirmation_instructions
class DevisePreview < ActionMailer::Preview
  def confirmation_instructions
    Devise::Mailer.confirmation_instructions(User.new, Devise.friendly_token)
  end
end