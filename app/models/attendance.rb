class Attendance < ApplicationRecord
  include DatetimeValidators

  belongs_to :user

  scope :recent, -> { order(started_at: :desc) }
  scope :in_this_month, -> { where(started_at: Time.current.all_month) }
  scope :on_term, -> (month) { where(started_at: Time.zone.strptime(month, '%Y/%m').all_month) }
  scope :calc_total_hours, -> { sum('finished_at - started_at').slice(0, 5) } # 返り値の文字列から、時間と分のみ抽出

  def self.all_terms
    pluck(:started_at).map { |a| a.strftime('%Y/%m') }.uniq
  end
end
