require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }

  describe 'GET #index' do
    context 'as authenticated user' do
      before do
        sign_in user
        get users_path
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
        get users_path
        expect(response).to redirect_to new_user_session_path
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

  describe 'DELETE #destroy' do

  end
end
