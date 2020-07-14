class WorkingResult < ApplicationRecord
  belongs_to :user
  has_many :attendances, dependent: :destroy

  scope :in_this_month, -> { where(term: Time.current.strftime('%Y/%m')) }
  scope :on_term, -> (month) { where(term: month) }
  scope :all_terms, -> { group(:term).pluck(:term) }
end
