class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :working_result

  validates_presence_of :started_at, :finished_at
  validate :validates_datetime

  before_validation :set_working_result
  after_commit :set_attributes_to_working_result
  after_destroy :destroy_working_result, unless: Proc.new { working_result.attendances.any? }

  scope :recent, -> { order(started_at: :desc) }
  scope :in_this_month, -> { where(started_at: Time.current.all_month) }
  scope :on_term, -> (month) { where(started_at: Time.zone.strptime(month, '%Y/%m').all_month) }

  def working_hours
    finished_at - started_at
  end

  private

  def validates_datetime
    if started_at.nil? || started_at > Date.today
      errors.add(:started_at, 'は今日以前の日時を選択してください')
    elsif finished_at.nil? || finished_at < started_at + 1.minutes
      errors.add(:finished_at, 'は出勤時刻より後の日時を選択してください')
    end
  end

  def set_working_result
    term = started_at.strftime('%Y/%m')
    working_result = WorkingResult.find_by(term: term, user: user)
    if working_result
      self.working_result = working_result
    else
      create_working_result(term: term, user: user)
    end
  end

  def set_attributes_to_working_result
    term = started_at.strftime('%Y/%m')
    working_result = WorkingResult.find_by(term: term, user: user)
    if working_result
      sum = 0
      working_result.attendances.map do |attendance|
        sum += attendance.working_hours
      end
      working_result.update_columns(total_time: sum, total_wage: sum * user.base_salary)
    end
  end

  def destroy_working_result
    working_result.destroy
  end
end
