require 'rails_helper'

RSpec.describe 'CreatedShifts', type: :request do
  let(:admin_user) { create(:admin_user) }
  let(:user) { create(:user) }
  let(:collected_shift) { create(:collected_shift) }
  let(:other_collected_shift) { create(:collected_shift) }
  let!(:created_shift) { create(:created_shift, collected_shift: collected_shift) }

  describe 'GET #index' do
    context 'as admin user' do
      before do
        sign_in admin_user
        get created_shifts_path
      end

      it 'returns http 200' do
        expect(response).to have_http_status(200)
      end

      it 'shows resources' do
        expect(response.body).to include created_shift.started_at.strftime('%H:%M')
        expect(response.body).to include created_shift.user.name
      end
    end

    context 'as general user' do
      before do
        sign_in user
        get created_shifts_path
      end

      it 'returns http 302' do
        expect(response).to have_http_status(302)
      end

      it 'redirects root' do
        expect(response).to redirect_to root_url
      end
    end
  end

  describe 'POST #create' do
    context 'as admin_user' do
      before { sign_in admin_user }

      context 'as valid params' do
        it 'returns http 302' do
          post collected_shift_created_shifts_path(other_collected_shift)
          expect(response).to have_http_status(302)
        end

        it 'redirects collected_shifts#index' do
          post collected_shift_created_shifts_path(other_collected_shift)
          expect(response).to redirect_to collected_shifts_path
        end

        it 'saved in database' do
          expect do
            post collected_shift_created_shifts_path(other_collected_shift)
          end.to change(CreatedShift, :count).by(1)
        end
      end
    end

    context 'as general user' do
      before { sign_in user }

      it 'returns http 302' do
        post collected_shift_created_shifts_path(other_collected_shift)
        expect(response).to have_http_status(302)
      end

      it 'redirects root' do
        post collected_shift_created_shifts_path(other_collected_shift)
        expect(response).to redirect_to root_url
      end

      it "isn't saved in database" do
        expect do
          post collected_shift_created_shifts_path(other_collected_shift)
        end.not_to change(CreatedShift, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as admin_user' do
      before { sign_in admin_user }

      it 'returns http 302' do
        delete collected_shift_created_shift_path(collected_shift, created_shift)
        expect(response).to have_http_status(302)
      end

      it 'redirects created_shifts#index' do
        delete collected_shift_created_shift_path(collected_shift, created_shift)
        expect(response).to redirect_to created_shifts_path
      end

      it 'deletes in database' do
        expect do
          delete collected_shift_created_shift_path(collected_shift, created_shift)
        end.to change(CreatedShift, :count).by(-1)
      end
    end

    context 'as general user' do
      before { sign_in user }

      it 'returns http 302' do
        delete collected_shift_created_shift_path(collected_shift, created_shift)
        expect(response).to have_http_status(302)
      end

      it 'redirects root' do
        delete collected_shift_created_shift_path(collected_shift, created_shift)
        expect(response).to redirect_to root_url
      end

      it "ins't deleted in database" do
        expect do
          delete collected_shift_created_shift_path(collected_shift, created_shift)
        end.not_to change(CreatedShift, :count)
      end
    end
  end
end
