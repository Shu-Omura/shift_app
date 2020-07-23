require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }
  let(:admin_user) { create(:admin_user) }
  let!(:user_2) { create(:user, name: 'user_2', company: company_2) }
  let(:company_2) { create(:company) }

  describe 'GET #index' do
    context 'as general user' do
      context 'as authenticated user' do
        before do
          sign_in user
          get users_path
        end

        it 'returns http 200' do
          expect(response).to have_http_status(200)
        end

        it 'shows users info about only name' do
          expect(response.body).to include user.name
          expect(response.body).not_to include user.email
        end

        it 'shows users info only colleagues' do
          expect(response.body).not_to include user_2.name
        end
      end

      context 'as guest' do
        it 'redirects to /sign_in' do
          get users_path
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    context 'as admin user' do
      before do
        sign_in admin_user
        get users_path
      end

      it 'returns http 200' do
        expect(response).to have_http_status(200)
      end

      it 'shows users info in detail' do
        expect(response.body).to include admin_user.name
        expect(response.body).to include admin_user.email
      end

      it 'shows users info only colleagues' do
        expect(response.body).not_to include user_2.name
      end
    end
  end

  describe 'GET #show' do
    context 'as authenticated user' do
      before do
        sign_in user
        get user_path(user)
      end

      it 'returns http 200' do
        expect(response).to have_http_status(200)
      end

      it 'shows resources' do
        expect(response.body).to include user.name
      end
    end

    context 'as guest' do
      it 'redirects to /sign_in' do
        get user_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
