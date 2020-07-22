require 'rails_helper'

RSpec.describe 'CreatedShifts', type: :request do
  let(:admin_user) { create(:admin_user, company: company) }
  let(:user) { create(:user, company: company) }
  let(:company) { create(:company) }

  let!(:created_shift) { create(:created_shift, collected_shift: non_determined) }
  let(:non_determined) { create(:non_determined, user: user) }

  let(:created_shift_params) { attributes_for(:created_shift, collected_shift: collected_shift) }
  let(:collected_shift) { create(:collected_shift, is_determined: status, user: user) }

  describe 'GET #index' do
    subject { get created_shifts_path }

    context 'as admin user' do
      before { sign_in admin_user }

      it { is_expected.to eq 200 }

      it 'shows created_shifts and users' do
        subject
        expect(response.body).to include created_shift.started_at.strftime('%H:%M')
        expect(response.body).to include created_shift.user.name
      end
    end

    context 'as general user' do
      before { sign_in user }

      it { is_expected.to eq 302 }
      it { is_expected.to redirect_to root_url }
    end
  end

  describe 'POST #create' do
    subject do
      post collected_shift_created_shifts_path(collected_shift),
                    params: { created_shift: created_shift_params }
    end

    context 'as admin_user' do
      before { sign_in admin_user }

      context 'with non_determined collected_shift' do
        let(:status) { false }

        it { is_expected.to eq 302 }
        it { is_expected.to redirect_to collected_shifts_path }
        it { expect { subject }.to change(CreatedShift, :count).by(1) }
      end
 
      context 'with determined collected_shift' do
        let(:status) { true }

        it { is_expected.to eq 200 }
        it { expect { subject }.not_to change(CreatedShift, :count) }
      end
    end

    context 'as general user' do
      before { sign_in user }

      it { is_expected.to eq 302 }
      it { is_expected.to redirect_to root_url }
      it { expect { subject }.not_to change(CreatedShift, :count) }
    end
  end

  describe 'DELETE #destroy' do
    subject { delete collected_shift_created_shift_path(non_determined, created_shift) }

    context 'as admin_user' do
      before { sign_in admin_user }

      it { is_expected.to eq 302 }
      it { is_expected.to redirect_to created_shifts_path }
      it { expect { subject }.to change(CreatedShift, :count).by(-1) }
    end

    context 'as general user' do
      before { sign_in user }

      it { is_expected.to eq 302 }
      it { is_expected.to redirect_to root_url }
      it { expect { subject }.not_to change(CreatedShift, :count) }
    end
  end
end
