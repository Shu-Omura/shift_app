require 'rails_helper'

RSpec.describe 'Attendances', type: :request do
  let(:admin_user) { create(:admin_user, company: company) }
  let(:user) { create(:user, company: company) }
  let(:user_2) { create(:user, company: company_2) }
  let(:company) { create(:company) }
  let(:company_2) { create(:company) }
  let!(:attendance) { create(:attendance, user: user) }
  let!(:attendance_2) { create(:attendance, user: user_2) }
  let(:attendance_params) { attributes_for(:attendance, user: user) }

  describe 'GET #index' do
    context 'as admin user' do
      before do
        sign_in admin_user
        get attendances_path
      end

      it 'returns http 200' do
        expect(response).to have_http_status(200)
      end

      it 'shows attendances info within colleagues' do
        expect(response.body).to include user.attendances_in_this_month.calc_total_hours.to_s
      end

      it 'is not show attendances info within other company' do
        expect(response.body).not_to include user_2.attendances_in_this_month.calc_total_hours.to_s
      end
    end

    context 'as general user' do
      before do
        sign_in user
        get attendances_path
      end

      it 'returns http 302' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to root' do
        expect(response).to redirect_to root_url
      end
    end
  end

  describe 'GET #new' do
    before do
      sign_in user
      get new_attendance_path
    end

    it 'returns http 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do
    subject { post attendances_path, params: { attendance: attendance_params } }

    before { sign_in user }

    it { is_expected.to eq 302 }
    it { is_expected.to redirect_to user }
    it { expect { subject }.to change(Attendance, :count).by(1) }
  end

  describe 'GET #edit' do
    context 'as admin user' do
      before { sign_in admin_user }

      context 'when edit own attendance' do
        let!(:attendance_3) { create(:attendance, user: admin_user) }

        before { get edit_attendance_path(attendance_3) }

        it 'returns http 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when edit other colleagues attendance' do
        before { get edit_attendance_path(attendance_2) }

        it 'returns http 200' do
          expect(response).to have_http_status(200)
        end
      end
    end

    context 'as general user' do
      before { sign_in user }

      context 'when edit own attendance' do
        before { get edit_attendance_path(attendance) }

        it 'returns http 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when edit other colleagues attendance' do
        before { get edit_attendance_path(attendance_2) }

        it 'returns http 302' do
          expect(response).to have_http_status(302)
        end

        it 'redirects to root' do
          expect(response).to redirect_to user
        end
      end
    end
  end

  describe 'PUT #update' do
    subject { put attendance_path(attendance), params: { attendance: attendance_params } }

    before { sign_in user }

    it { is_expected.to eq 302 }
    it { is_expected.to redirect_to user }
    it 'updates database' do      
      subject
      expect(attendance.reload.finished_at.min).to eq attendance_params[:finished_at].min
    end
  end

  describe 'DELETE #destroy' do
    let!(:attendance_3) { create(:attendance, user: admin_user) }
    subject { delete attendance_path(delete_attendance) }

    context 'as admin user' do
      before { sign_in admin_user }

      context 'when delete own attendnace' do
        let(:delete_attendance) { attendance_3 }

        it { is_expected.to eq 302 }
        it { is_expected.to redirect_to admin_user }
        it { expect { subject }.to change(Attendance, :count).by(-1) }
      end

      context 'when delete colleagues attendances' do
        let(:delete_attendance) { attendance }

        it { is_expected.to eq 302 }
        it { is_expected.to redirect_to admin_user }
        it { expect { subject }.to change(Attendance, :count).by(-1) }
      end
    end

    context 'as general user' do
      before { sign_in user }

      context 'when delete own attendnace' do
        let(:delete_attendance) { attendance }

        it { is_expected.to eq 302 }
        it { is_expected.to redirect_to user }
        it { expect { subject }.to change(Attendance, :count).by(-1) }
      end

      context 'when delete colleagues attendances' do
        let(:delete_attendance) { attendance_3 }

        it { is_expected.to eq 302 }
        it { is_expected.to redirect_to user }
        it { expect { subject }.not_to change(Attendance, :count) }
      end
    end
  end
end
