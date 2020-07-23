class CreatedShift < ApplicationRecord
  belongs_to :collected_shift
  delegate :user, to: :collected_shift

  include DatetimeValidators
  validate :validates_after_today
  validate :validates_is_determined

  scope :user_created_shifts, -> (user_ids) { joins(collected_shift: :user).where(users: { id: user_ids }) }

  after_create :update_collected_shift_is_determined
  after_destroy :downdate_collected_shift_is_determined

  # simple_calendar用エイリアス
  def start_time
    started_at
  end

  private

  def validates_after_today
    return false if started_at.nil? || finished_at.nil?
    if started_at < Date.today
      errors.add(:collected_shift, '：過去のシフトを選択することはできません')
    end
  end

  def validates_is_determined
    if collected_shift.is_determined == true
      errors.add(:collected_shift, '：すでに確定済みのシフトを選択することはできません')
    end
  end

  def update_collected_shift_is_determined
    collected_shift.update_columns(is_determined: true)
  end

  def downdate_collected_shift_is_determined
    collected_shift.update_columns(is_determined: false)
  end
end
