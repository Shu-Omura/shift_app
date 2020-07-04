class CreatedShift < ApplicationRecord
  belongs_to :collected_shift, -> { where(is_determined: true) }, touch: true
  delegate :user, to: :collected_shift
  validates_presence_of :started_at, :finished_at
  validate :validates_datetime

  # simple_calendar用エイリアス
  def start_time
    started_at
  end

  private

  def validates_datetime
    if started_at.nil? || started_at < Date.today
      errors.add(:started_at, "は今日以降の日時を選択してください")
    elsif finished_at.nil? || finished_at < started_at + 1.minute
      errors.add(:finished_at, "は出勤時刻より後の日時を選択してください")
    end
  end
end
