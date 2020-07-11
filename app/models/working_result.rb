class WorkingResult < ApplicationRecord
  belongs_to :user
  has_many :attendances, dependent: :destroy

  scope :in_this_month, -> { where(term: Time.current.strftime("%Y/%m")) }
end
