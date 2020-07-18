module DatetimeValidators
  extend ActiveSupport::Concern

  included do
    validates :started_at, presence: true
    validates :finished_at, presence: true
    validate :validates_finished_at_before_started_at
    validate :validates_before_today
    validate :validates_over_1day

    private

    def validates_before_today
      return false if started_at.nil? || finished_at.nil?
      if started_at > Date.today
        errors.add(:started_at, 'は今日以前の日時を選択してください')
      end
    end
  
    def validates_finished_at_before_started_at
      return false if started_at.nil? || finished_at.nil?
      if finished_at < started_at + 1.minutes
        errors.add(:finished_at, 'は出勤時刻より後の日時を選択してください')
      end
    end
  
    def validates_over_1day
      return false if started_at.nil? || finished_at.nil?
      if finished_at - started_at >= 86400
        errors.add(:finished_at, 'は24時間未満で選択してください')
      end
    end
  end
end
