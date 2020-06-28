class CollectedShift < ApplicationRecord
  belongs_to :user
  validates_presence_of :started_at
  validates_presence_of :finished_at
  validate :validates_datetime

  private

  def validates_datetime
    if started_at.nil? || started_at < Date.today
      errors.add(:started_at, '今日以降の日時を選択してください')
    elsif finished_at.nil? || finished_at < started_at + 1.minute
      errors.add(:finished_at, '開始時刻より後の日時を選択してください')
    end
  end
end
