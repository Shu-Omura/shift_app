class CollectedShift < ApplicationRecord
  include DatetimeValidators

  belongs_to :user
  has_one :created_shift, autosave: true, dependent: :destroy

  # simple_calendar用エイリアス
  def start_time
    started_at
  end
end
