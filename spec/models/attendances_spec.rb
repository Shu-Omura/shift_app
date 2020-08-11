require 'rails_helper'

RSpec.describe 'Attendances', type: :model do
  let(:attendance) { build(:attendance) }

  describe 'validation' do
    it 'is valid factory' do
      expect(attendance).to be_valid
    end

    it 'is invalid without started_at' do
      attendance.started_at = nil
      expect(attendance).not_to be_valid
    end

    it 'is invalid without finished_at' do
      attendance.finished_at = nil
      expect(attendance).not_to be_valid
    end

    context 'as custom validation' do
      let(:attendance_2) { build(:attendance,
                                 started_at: started_at,
                                 finished_at: finished_at,
                                )
                         }
      
      context 'as validates_before_today' do
        let(:started_at) { Time.current }
        let(:finished_at) { Time.current.since(1.hour) }
  
        it "is invalid with today's attendance" do
          expect(attendance_2).not_to be_valid
        end
      end
  
      context 'as validates_finished_at_before_started_at' do
        let(:started_at) { Time.current.ago(1.day) }
        let(:finished_at) { started_at.ago(1.hour) }
  
        it 'is invalid with finished_at before started_at' do
          expect(attendance_2).not_to be_valid
        end
      end
  
      context 'as validates_over_1day' do
        let(:started_at) { Time.current.ago(2.day) }
        let(:finished_at) { started_at.since(1.day) }

        it 'is invalid with over 1day from started_at to finished_at' do
          expect(attendance_2).not_to be_valid
        end
      end
    end
  end

  describe 'scope' do
    context 'recent' do
      let!(:attendance_1) { create(:attendance, started_at: Time.current.ago(2.days)) }
      let!(:attendance_2) { create(:attendance, started_at: Time.current.ago(1.days)) }

      it 'shows attendances descending order as started_at' do
        expect(Attendance.first).to eq attendance_1
        expect(Attendance.recent.first).to eq attendance_2
      end
    end

    context 'in_this_month' do
      let!(:attendance_1) { create(:attendance, started_at: Time.current.ago(1.month)) }
      let!(:attendance_2) { create(:attendance, started_at: Time.current.ago(1.day)) }

      it 'shows attendances only this month' do
        expect(Attendance.in_this_month).to include attendance_2
        expect(Attendance.in_this_month).not_to include attendance_1
      end
    end

    context 'on_term' do
      let!(:attendance_1) { create(:attendance, started_at: Time.current.ago(2.month)) }
      let!(:attendance_2) { create(:attendance, started_at: Time.current.ago(1.month)) }

      before do
        @ago_1_month = Time.current.ago(1.month).strftime('%Y/%m')
        @ago_2_months = Time.current.ago(2.month).strftime('%Y/%m')
      end

      it 'shows attendances only 1 month ago' do
        expect(Attendance.on_term(@ago_1_month)).to include attendance_2
        expect(Attendance.on_term(@ago_1_month)).not_to include attendance_1
      end

      it 'shows attendances only 2 months ago' do
        expect(Attendance.on_term(@ago_2_months)).to include attendance_1
        expect(Attendance.on_term(@ago_2_months)).not_to include attendance_2
      end
    end

    context 'calc_total_hours' do
      let!(:attendance_1) { create(:attendance,
                                   started_at: Time.current.ago(1.day),
                                   finished_at: Time.current.ago(1.day).since(1.hour)) }
      let!(:attendance_2) { create(:attendance,
                                   started_at: Time.current.ago(2.days),
                                   finished_at: Time.current.ago(2.day).since(2.hours)) }
      
      it 'calcs total hours' do
        expect(Attendance.calc_total_hours).to eq '03:00'
      end
    end
  end
end