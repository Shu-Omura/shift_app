class Attendance < ApplicationRecord
  belongs_to :user

  include DatetimeValidators
  validate :validates_before_today

  scope :recent, -> { order(started_at: :desc) }
  scope :in_this_month, -> { where(started_at: Time.current.all_month) }
  scope :on_term, -> (month) { where(started_at: Time.zone.strptime(month, '%Y/%m').all_month) }
  scope :calc_total_hours, -> { sum('finished_at - started_at').match(/(.*):/)[1] } # 返り値の文字列から、時間と分のみ抽出

  def self.all_terms
    pluck(:started_at).map { |a| a.strftime('%Y/%m') }.uniq
  end

  private

  def validates_before_today
    return false if started_at.nil? || finished_at.nil?
    if started_at > Date.today
      errors.add(:started_at, 'は今日以前の日時を選択してください')
    end
  end
end
