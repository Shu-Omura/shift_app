class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i(facebook google_oauth2)
  has_many :collected_shifts, dependent: :destroy
  has_many :created_shifts, through: :collected_shifts
  has_many :attendances, dependent: :destroy
  belongs_to :company, optional: true

  validates :name, presence: true
  validate :min_base_salary

  scope :colleagues, -> (user) { where(company_id: user.company_id) }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
    end
  end

  def attendances_on_term(month)
    Attendance.on_term(month).where(user: self)
  end

  def attendances_in_this_month
    Attendance.in_this_month.where(user: self)
  end

  def calc_total_wage(term)
    total_hours = attendances_on_term(term).calc_total_hours
    str = total_hours.match(/(.*):(.*)/)
    total_wage = (str[1].to_i + str[2].to_f / 60) * base_salary
    total_wage.floor
  end

  def update_with_authentication(resource, params)
    company = Company.find_by(name: params[:company])
    if company && company.auth_token == params[:company_auth_token]
      resource.update(company: company)
    else
      errors.add(:company, '情報が正しくありません')
      false
    end
  end

  private

  def min_base_salary
    if base_salary < 790
      errors.add(:base_salary, 'が低すぎます')
    end
  end
end
