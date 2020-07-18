class CreatedShift < ApplicationRecord
  belongs_to :collected_shift, -> { where(is_determined: true) }, touch: true
  delegate :user, to: :collected_shift

  include DatetimeValidators
  validate :validates_after_today

  scope :user_created_shifts, -> (user_ids) { joins(collected_shift: :user).where(users: { id: user_ids }) }

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
