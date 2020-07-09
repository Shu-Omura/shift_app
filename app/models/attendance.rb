class Attendance < ApplicationRecord
  belongs_to :user
  validates_presence_of :started_at, :finished_at
  validate :validates_datetime
  default_scope -> { order(started_at: :desc) }

  private

  def validates_datetime
    if started_at.nil? || started_at > Date.today
      errors.add(:started_at, "は今日以前の日時を選択してください")
    elsif finished_at.nil? || finished_at < started_at + 1.minute
      errors.add(:finished_at, "は出勤時刻より後の日時を選択してください")
    end
  end
end
