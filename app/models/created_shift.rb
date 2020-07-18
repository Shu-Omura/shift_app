class CreatedShift < ApplicationRecord
  include DatetimeValidators

  belongs_to :collected_shift, -> { where(is_determined: true) }, touch: true
  delegate :user, to: :collected_shift

  scope :user_created_shifts, -> (user_ids) { joins(collected_shift: :user).where(users: { id: user_ids }) }

  # simple_calendar用エイリアス
  def start_time
    started_at
  end
end
