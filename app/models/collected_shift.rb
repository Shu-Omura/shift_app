class CollectedShift < ApplicationRecord
  belongs_to :user
  validates_presence_of :started_at, :finished_at
  validate :validates_datetime
  validate :validates_datetime_format
end
