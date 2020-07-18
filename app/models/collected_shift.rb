class CollectedShift < ApplicationRecord
  belongs_to :user
  has_one :created_shift, autosave: true, dependent: :destroy

  include DatetimeValidators
  validate :validates_after_today

  # simple_calendar用エイリアス
  def start_time
    started_at
  end

  private

  def validates_after_today
    return false if started_at.nil? || finished_at.nil?
    if started_at < Date.today
      errors.add(:started_at, 'は今日以降の日時を選択してください')
    end
  end
end
