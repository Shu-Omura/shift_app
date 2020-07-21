require 'rails_helper'

RSpec.describe 'CollectedShifts', type: :request do
  let(:user) { create(:user) }
  let(:collected_shift_params) do
    attributes_for(:collected_shift,
                   started_at: Time.current + 2.days,
                   finished_at: Time.current + 2.days + 1.hour,
                   user: user)
  end
  let(:invalid_collected_shift_params) do
    attributes_for(:collected_shift,
                   started_at: Time.current + 2.days,
                   finished_at: nil,
                   user: user)
  end

  describe 'GET #index' do
    let!(:collected_shift) { create(:collected_shift, user: user) }

    context 'as authenticated user' do
      before do
        sign_in user
        get collected_shifts_path
      end

      it 'returns http 200' do
        expect(response).to have_http_status(200)
      end

      it 'shows collected_shifts and user names' do
        expect(response.body).to include collected_shift.started_at.strftime('%H:%M')
        expect(response.body).to include user.name
      end
    end

    context 'as a guest' do
      before { get collected_shifts_path }

      it 'returns http 302' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to registration#new' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    let!(:collected_shift) { create(:collected_shift, user: user) }

    before { sign_in user }

    context 'as valid params' do
      it 'returns http 302' do
        post collected_shifts_path, params: { collected_shift: collected_shift_params }
        expect(response).to have_http_status(302)
      end

      it 'redirects to users#show' do
        post collected_shifts_path, params: { collected_shift: collected_shift_params }
        expect(response).to redirect_to user
      end

      it 'saved in database' do
        expect do
          post collected_shifts_path, params: { collected_shift: collected_shift_params }
        end.to change(CollectedShift, :count).by(1)
      end
    end

    context 'as invalid params' do
      it 'returns http 200' do
        post collected_shifts_path, params: { collected_shift: invalid_collected_shift_params }
        expect(response).to have_http_status(200)
      end

      it "isn't saved in database" do
        expect do
          post collected_shifts_path, params: { collected_shift: invalid_collected_shift_params }
        end.not_to change(CollectedShift, :count)
      end

      it 'shows error messages' do
        post collected_shifts_path, params: { collected_shift: invalid_collected_shift_params }
        expect(response.body).to include '退勤時刻を入力してください'
      end
    end
  end

  describe 'GET #edit' do
    let!(:collected_shift) { create(:collected_shift, is_determined: status, user: user) }

    before do
      sign_in user
      get edit_collected_shift_path(collected_shift)
    end

    context 'with not determined collected_shift' do
      let(:status) { false }

      it 'returns http 200' do
        expect(response).to have_http_status(200)
      end

      it 'shows collected_shift' do
        expect(response.body).to include collected_shift.started_at.day.to_s
        expect(response.body).to include collected_shift.finished_at.day.to_s
      end
    end

    context 'with determined collected_shift' do
      let(:status) { true }

      it 'returns http 302' do
        expect(response).to have_http_status(302)
      end
      
      it 'redirects to users#show' do
        expect(response).to redirect_to user
      end
    end
  end

  describe 'PUT #update' do
    let!(:collected_shift) { create(:collected_shift, is_determined: status, user: user) }

    before { sign_in user }

    context 'with not determined collected_shift' do
      let(:status) { false }

      context 'as valid params' do
        before do
          put collected_shift_path(collected_shift),
                params: { collected_shift: collected_shift_params }
        end

        it 'returns http 302' do
          expect(response).to have_http_status(302)
        end

        it 'redirects to users#show' do
          expect(response).to redirect_to user
        end

        it 'updates database' do
          expect(collected_shift.reload.started_at.day).to eq Time.current.next_day(2).day
        end
      end

      context 'as invalid params' do
        before do
          put collected_shift_path(collected_shift),
                params: { collected_shift: invalid_collected_shift_params }
        end

        it 'returns http 200' do
          expect(response).to have_http_status(200)
        end

        it 'is not updated database' do
          expect(collected_shift.reload.started_at.day).not_to eq Time.current.next_day(2).day
        end

        it 'shows error messages' do
          expect(response.body).to include '退勤時刻を入力してください'
        end
      end
    end

    context 'with determined collected_shift' do
      let(:status) { true }

      before do
        put collected_shift_path(collected_shift),
              params: { collected_shift: collected_shift_params }
      end

      it 'returns http 302' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to users#show' do
        expect(response).to redirect_to user
      end

      it 'is not updated database' do
        expect(collected_shift.reload.started_at.day).not_to eq Time.current.next_day(2).day
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:collected_shift) { create(:collected_shift, is_determined: status, user: user) }
    
    context 'with not determined collected_shift' do
      let(:status) { false }

      context 'as authenticated user' do
        before { sign_in user }

        it 'returns http 302' do
          delete collected_shift_path(collected_shift)
          expect(response).to have_http_status(302)
        end

        it 'redirects to users#show' do
          delete collected_shift_path(collected_shift)
          expect(response).to redirect_to user_path(user)
        end

        it 'deletes in database' do
          expect do
            delete collected_shift_path(collected_shift)
          end.to change(CollectedShift, :count).by(-1)
        end
      end

      context 'as guest' do
        it 'returns http 200' do
          delete collected_shift_path(collected_shift)
          expect(response).to have_http_status(302)
        end

        it 'redirects to registration#new' do
          delete collected_shift_path(collected_shift)
          expect(response).to redirect_to new_user_session_path
        end

        it 'is not deleted in database' do
          expect do
            delete collected_shift_path(collected_shift)
          end.not_to change(CollectedShift, :count)
        end
      end
    end

    context 'with determined collected_shift' do
      let(:status) { true }

      it 'returns http 302' do
        delete collected_shift_path(collected_shift)
        expect(response).to have_http_status(302)
      end

      it 'is not changed in database' do
        expect do
          delete collected_shift_path(collected_shift)
        end.not_to change(CollectedShift, :count)
      end
    end
  end
end
