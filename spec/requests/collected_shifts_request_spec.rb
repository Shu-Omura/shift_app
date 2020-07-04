require "rails_helper"

RSpec.describe "CollectedShifts", type: :request do
  let(:user) { create(:user) }
  let!(:collected_shift) { create(:collected_shift, user: user) }
  let(:collected_shift_params) do
    attributes_for(:collected_shift,
                   finished_at: DateTime.new(2030, 1, 2, 0, 0, 0), user: user)
  end
  let(:invalid_collected_shift_params) do
    attributes_for(:collected_shift,
                   started_at: Time.current - 1.days, user: user)
  end

  describe "GET #index" do
    context "as authenticated user" do
      before do
        sign_in user
        get collected_shifts_path
      end

      it "returns http 200" do
        expect(response).to have_http_status(200)
      end

      it "shows collected_shifts and users resources" do
        expect(response.body).to include collected_shift.started_at.strftime("%-H:%-M")
        expect(response.body).to include user.name
      end
    end

    context "as a guest" do
      before { get collected_shifts_path }

      it "returns http 302" do
        expect(response).to have_http_status(302)
      end

      it "redirects to /sign_in" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #new" do
    context "as authenticated user" do
      before do
        sign_in user
        get new_collected_shift_path
      end

      it "returns http 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "as guest" do
      before { get new_collected_shift_path }

      it "returns http 302" do
        expect(response).to have_http_status(302)
      end

      it "redirects to /sign_in" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #create" do
    before { sign_in user }

    context "as valid params" do
      it "returns http 302" do
        post collected_shifts_path, params: { collected_shift: collected_shift_params }
        expect(response).to have_http_status(302)
      end

      it "redirects to /users" do
        post collected_shifts_path, params: { collected_shift: collected_shift_params }
        expect(response).to redirect_to user_path(user)
      end

      it "saved in database" do
        expect do
          post collected_shifts_path, params: { collected_shift: collected_shift_params }
        end.to change(CollectedShift, :count).by(1)
      end
    end

    context "as invalid params" do
      it "returns http 200" do
        post collected_shifts_path, params: { collected_shift: invalid_collected_shift_params }
        expect(response).to have_http_status(200)
      end

      it "isn't saved in database" do
        expect do
          post collected_shifts_path, params: { collected_shift: invalid_collected_shift_params }
        end.not_to change(CollectedShift, :count)
      end

      it "shows error messages" do
        post collected_shifts_path, params: { collected_shift: invalid_collected_shift_params }
        expect(response.body).to include "出勤時刻は今日以降の日時を選択してください"
      end
    end
  end

  describe "GET #edit" do
    context "as authenticated user" do
      before do
        sign_in user
        get edit_collected_shift_path(collected_shift)
      end

      it "returns http 200" do
        expect(response).to have_http_status(200)
      end

      it "shows resources" do
        expect(response.body).to include collected_shift.started_at.day.to_s
        expect(response.body).to include collected_shift.finished_at.day.to_s
      end
    end

    context "as guest" do
      before { get edit_collected_shift_path(collected_shift) }

      it "returns http 302" do
        expect(response).to have_http_status(302)
      end

      it "redirects to /sign_in" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH #update" do
    before { sign_in user }

    context "as valid params" do
      before do
        patch collected_shift_path(collected_shift),
              params: { collected_shift: collected_shift_params }
      end

      it "returns http 302" do
        expect(response).to have_http_status(302)
      end

      it "redirects to /users" do
        expect(response).to redirect_to user_path(user)
      end

      it "updates database" do
        expect(collected_shift.reload.finished_at).to eq(DateTime.new(2030, 1, 2, 0, 0, 0))
      end
    end

    context "as invalid params" do
      before do
        patch collected_shift_path(collected_shift),
              params: { collected_shift: invalid_collected_shift_params }
      end

      it "returns http 200" do
        expect(response).to have_http_status(200)
      end

      it "isn't updated database" do
        expect(collected_shift.reload.started_at).not_to eq(DateTime.new(2000, 1, 2, 0, 0, 0))
      end

      it "shows error messages" do
        expect(response.body).to include "出勤時刻は今日以降の日時を選択してください"
      end
    end
  end

  describe "DELETE #destroy" do
    context "as authenticated user" do
      before { sign_in user }

      it "returns http 302" do
        delete collected_shift_path(collected_shift)
        expect(response).to have_http_status(302)
      end

      it "redirects to /users" do
        delete collected_shift_path(collected_shift)
        expect(response).to redirect_to user_path(user)
      end

      it "deletes in database" do
        expect do
          delete collected_shift_path(collected_shift)
        end.to change(CollectedShift, :count).by(-1)
      end
    end

    context "as guest" do
      it "returns http 200" do
        delete collected_shift_path(collected_shift)
        expect(response).to have_http_status(302)
      end

      it "redirects to /sign_in" do
        delete collected_shift_path(collected_shift)
        expect(response).to redirect_to new_user_session_path
      end

      it "isn't deleted in database" do
        expect do
          delete collected_shift_path(collected_shift)
        end.not_to change(CollectedShift, :count)
      end
    end
  end
end
