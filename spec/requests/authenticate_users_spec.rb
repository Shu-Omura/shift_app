require 'rails_helper'

RSpec.describe 'AuthenticateUsers', type: :request do
  let(:user) { create(:user) }

  describe 'registrations' do
    describe 'GET #new' do
      context 'as authenticated user' do
        before do 
          sign_in user
          get new_user_registration_path
        end

        it 'returns http 302' do
          expect(response).to have_http_status(302)
        end

        it 'redirects to root' do
          expect(response).to redirect_to user
        end
      end
    
      context 'as guest' do
        before { get new_user_registration_path }

        it 'returns http 200' do
          expect(response).to have_http_status(200)
        end
      end
    end

    describe 'POST #create' do
      let(:user_params) { attributes_for(:user, name: name) }

      context 'as valid params' do
        let(:name) { 'test' }

        it 'returns http 302' do
          post user_registration_path, params: { user: user_params }
          expect(response).to have_http_status(302)
        end

        it 'redirects to #show' do
          post user_registration_path, params: { user: user_params }
          expect(response).to redirect_to User.last
        end

        it 'is saved in database' do
          expect do
            post user_registration_path, params: { user: user_params }
          end.to change(User, :count).by(1)
        end
      end

      context 'as invalid params' do
        let(:name) { '' }

        it 'returns http 200' do
          post user_registration_path, params: { user: user_params }
          expect(response).to have_http_status(200)
        end

        it 'is not saved in database' do
          expect do
            post user_registration_path, params: { user: user_params }
          end.not_to change(User, :count)
        end

        it 'shows error messages' do
          post user_registration_path, params: { user: user_params }
          expect(response.body).to include '名前を入力してください'
        end
      end
    end

    describe 'GET #edit' do
      context 'as authenticated user' do
        before do
          sign_in user
          get edit_user_registration_path
        end
  
        it 'returns http 200' do
          expect(response).to have_http_status(200)
        end
  
        it 'shows user' do
          expect(response.body).to include user.name
          expect(response.body).to include user.email
        end
      end
    
      context 'as guest' do
        before { get edit_user_registration_path }

        it 'redirects to sessions#new' do
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    describe 'PUT #update' do
      let(:user_2) { create(:user, email: 'sample@test.com') }

      before { sign_in user_2 }
      
      context 'when update name' do
        let(:user_params) { attributes_for(:user,
                                           email: 'sample@test.com',
                                           name: 'New Name',
                                           current_password: password) }
        
        context 'as valid params(with current_password)' do
          let(:password) { 'password' }

          before { put user_registration_path, params: { user: user_params } }
  
          it 'returns http 302' do
            expect(response).to have_http_status(302)
          end
  
          it 'redirects to #show' do
            expect(response).to redirect_to user_2
          end
  
          it 'updates database' do
            expect(user_2.reload.name).to eq 'New Name'
          end
        end
  
        context 'as invalid params(without current_password)' do
          let(:password) { '' }

          before { put user_registration_path, params: { user: user_params } }
  
          it 'returns http 200' do
            expect(response).to have_http_status(200)
          end
  
          it 'shows error messages' do
            expect(response.body).to include '現在のパスワードを入力してください'
          end
        end
      end

      context 'when update pasword' do
        let(:user_params) { attributes_for(:user,
                                    email: 'sample@test.com',
                                    name: 'New Name',
                                    password: 'newpassword',
                                    password_confirmation: 'newpassword',
                                    current_password: password) }
        
        context 'as valid params(with current_password)' do
          let(:password) { 'password' }

          before { put user_registration_path, params: { user: user_params } }

          it 'returns http 302' do
            expect(response).to have_http_status(302)
          end
  
          it 'redirects to #show' do
            expect(response).to redirect_to user_2
          end
  
          it 'updates database' do
            expect(user_2.reload.valid_password?('newpassword')).to be true
          end
        end

        context 'as invalid params(without current_password)' do
          let(:password) { '' }

          before { put user_registration_path, params: { user: user_params } }

          it 'returns http 200' do
            expect(response).to have_http_status(200)
          end
  
          it 'shows error messages' do
            expect(response.body).to include '現在のパスワードを入力してください'
          end
        end
      end
      
    end

    describe 'DELETE #destroy' do
      context 'as authenticated user' do
        before { sign_in user }
  
        it 'returns http 302' do
          delete user_registration_path
          expect(response).to have_http_status(302)
        end
  
        it 'redirects to root' do
          delete user_registration_path
          expect(response).to redirect_to root_url
        end
  
        it 'deletes in database' do
          expect do
            delete user_registration_path
          end.to change(User, :count).by(-1)
        end
      end
  
      context 'as guest' do
        it 'returns http 200' do
          delete user_registration_path
          expect(response).to have_http_status(302)
        end
  
        it 'redirects to sessions#new' do
          delete user_registration_path
          expect(response).to redirect_to new_user_session_path
        end
  
        it 'is not deleted in database' do
          expect do
            delete user_registration_path
          end.not_to change(User, :count)
        end
      end
    end
  end

  describe 'sessions' do
    describe 'GET #new' do
      context 'as authenticated user' do
        before do
          sign_in user
          get new_user_session_path
        end
        
        it 'returns http 302' do
          expect(response).to have_http_status(302)  
        end
        
        it 'redirects to registration#show' do
          expect(response).to redirect_to user  
        end
      end

      context 'as guest' do
        before { get new_user_session_path }

        it 'returns http 200' do
          expect(response).to have_http_status(200)  
        end
      end
    end

    describe 'POST #create' do
      let!(:user_2) { create(:user, email: 'sample@test.com') }
      let(:user_params) { attributes_for(:user, email: 'sample@test.com') }

      before { post user_session_path, params: { user: user_params } }

      it 'returns http 302' do
        expect(response).to have_http_status(302)  
      end

      it 'redirects to registration#show' do
        expect(response).to redirect_to user_2
      end

      it 'shows flash message' do
        get user_path(user_2)
        expect(response.body).to include 'ログインしました。'  
      end
    end

    describe 'DELETE #destroy' do
      before do
        sign_in user
        delete destroy_user_session_path
      end

      it 'returns http 302' do
        expect(response).to have_http_status(302)  
      end

      it 'redirect_to root' do
        expect(response).to redirect_to root_url  
      end

      it 'shows flash message' do
        get root_url
        expect(response.body).to include 'ログアウトしました。'  
      end
    end
  end

  describe 'omniauth_callbacks' do
    before do
      Rails.application.env_config['omniauth.auth'] = facebook_mock
    end

    it 'returns http 302' do
      get user_facebook_omniauth_callback_path
      expect(response).to have_http_status(302)  
    end

    it 'redirects to #show' do
      get user_facebook_omniauth_callback_path
      expect(response).to redirect_to User.last 
    end

    context 'when user is not exist' do
      it 'saves in database' do
        expect do
          get user_facebook_omniauth_callback_path
        end.to change(User, :count).by(1)
      end
    end

    context 'when user is already exist' do
      # facabook_mockと同じ属性
      let!(:user_2) { create(:user, name: 'mockuser', email: 'sample@test.com', uid: '12345', provider: 'facebook') }

      it 'does not save in database' do
        expect do  
          get user_facebook_omniauth_callback_path
        end.not_to change(User, :count)
      end
    end
  end

  describe 'passwords' do
    pending
  end
end
