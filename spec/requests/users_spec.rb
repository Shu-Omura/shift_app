require "rails_helper"

RSpec.describe "Users", type: :request do
  let!(:user) { create(:user) }

  describe "GET #index" do
    context "as authenticated user" do
      before do
        sign_in user
        get users_path
      end

      it "returns http 200" do
        expect(response).to have_http_status(200)
      end

      it "shows resources" do
        expect(response.body).to include user.name
      end
    end

    context "as guest" do
      it "redirects to /sign_in" do
        get users_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #show" do
    context "as authenticated user" do
      before do
        sign_in user
        get user_path(user)
      end

      it "returns http 200" do
        expect(response).to have_http_status(200)
      end
      it "shows resources" do
        expect(response.body).to include user.name
      end
    end

    context "as guest" do
      it "redirects to /sign_in" do
        get user_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #new" do
    context "as authenticated user" do
      it "redirects to /" do
        sign_in user
        get new_user_registration_path
        expect(response).to redirect_to user_path(user)
      end
    end

    context "as guest" do
      it "returns http 200" do
        get new_user_registration_path
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "POST #create" do
    context "as valid params" do
      let(:user_params) { attributes_for(:user) }

      it "returns http 302" do
        post user_registration_path, params: { user: user_params }
        expect(response).to have_http_status(302)
      end

      it "redirects to /" do
        post user_registration_path, params: { user: user_params }
        expect(response).to redirect_to root_url
      end

      it "is saved in database" do
        expect do
          post user_registration_path, params: { user: user_params }
        end.to change(User, :count).by(1)
      end
    end

    context "as not valid params" do
      let!(:invalid_user_params) { attributes_for(:user, name: "") }

      it "returns http 200" do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response).to have_http_status(200)
      end

      it "isn't saved in database" do
        expect do
          post user_registration_path, params: { user: invalid_user_params }
        end.not_to change(User, :count)
      end

      it "shows error messages" do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response.body).to include "名前を入力してください"
      end
    end
  end

  describe "GET #edit" do
    context "as authenticated user" do
      before do
        sign_in user
        get edit_user_registration_path
      end

      it "returns http 200" do
        expect(response).to have_http_status(200)
      end

      it "shows resources" do
        expect(response.body).to include user.name
        expect(response.body).to include user.email
      end
    end

    context "as guest" do
      it "redirects to /" do
        get edit_user_registration_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #update" do
    before do
      @fixed_user = create(:fixed_user)
      sign_in @fixed_user
    end

    context "when update name" do
      context "as valid params(with current_password)" do
        before do
          patch user_registration_path,
                params: { user: attributes_for(:fixed_user,
                                               name: "New Name",
                                               current_password: "foobar") }
        end

        it "returns http 302" do
          expect(response).to have_http_status(302)
        end

        it "redirects to #show" do
          expect(response).to redirect_to root_url
        end

        it "updates database" do
          expect(@fixed_user.reload.name).to eq "New Name"
        end
      end

      context "as invalid params(without current_password)" do
        before { patch user_registration_path, params: { user: attributes_for(:fixed_user, name: "New Name") } }

        it "returns http 200" do
          expect(response).to have_http_status(200)
        end

        it "shows error messages" do
          expect(response.body).to include "現在のパスワードを入力してください"
        end
      end
    end

    context "when update password" do
      context "as valid params(with current_password)" do
        before do
          patch user_registration_path,
                params: { user: attributes_for(:fixed_user,
                                               name: "New Name",
                                               current_password: "foobar",
                                               password: "newpassword",
                                               password_confirmation: "newpassword") }
        end

        it "returns http 302" do
          expect(response).to have_http_status(302)
        end

        it "redirects to #show" do
          expect(response).to redirect_to root_url
        end

        it "updates database" do
          expect(@fixed_user.reload.valid_password?("newpassword")).to be true
        end
      end

      context "as invalid params(without current_password)" do
        before do
          patch user_registration_path, params: { user: attributes_for(:fixed_user,
                                                                       password: "newpassword",
                                                                       password_confirmation: "newpassword") }
        end

        it "returns http 200" do
          expect(response).to have_http_status(200)
        end

        it "shows error messages" do
          expect(response.body).to include "現在のパスワードを入力してください"
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "as authenticated user" do
      before { sign_in user }

      it "returns http 302" do
        delete user_registration_path
        expect(response).to have_http_status(302)
      end

      it "redirects to /" do
        delete user_registration_path
        expect(response).to redirect_to root_url
      end

      it "deletes in database" do
        expect do
          delete user_registration_path
        end.to change(User, :count).by(-1)
      end
    end

    context "as guest" do
      it "returns http 200" do
        delete user_registration_path
        expect(response).to have_http_status(302)
      end

      it "redirects to /sign_in" do
        delete user_registration_path
        expect(response).to redirect_to new_user_session_path
      end

      it "isn't deleted in database" do
        expect do
          delete user_registration_path
        end.not_to change(User, :count)
      end
    end
  end
end
