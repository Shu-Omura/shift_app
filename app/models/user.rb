class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i(facebook google_oauth2)
  has_many :collected_shifts, dependent: :destroy
  has_many :determined_shifts, through: :collected_shifts, source: :created_shift
  validates_presence_of :name
  scope :colleagues, -> (user) { where(company_id: user.company_id) }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.skip_confirmation!
    end
  end
end
