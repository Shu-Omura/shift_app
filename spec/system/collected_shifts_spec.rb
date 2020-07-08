require "rails_helper"

RSpec.describe "CollectedShifts", type: :system do
  let(:user) { create(:user) }
  let!(:collected_shift) { create(:collected_shift, user: user) }

  before do
    sign_in user
    visit user_path(user)
  end

  it "creates collected_shifts" do
    expect do
      fill_in 'collected_shift_started_at', with: Time.current
      fill_in 'collected_shift_finished_at', with: Time.current + 1.hour

      click_button "提出"

      expect(page).to have_content "シフトを提出しました"
    end.to change(CollectedShift, :count).by(1)

    visit user_path(user)

    expect(page).to have_content CollectedShift.count
    expect(page).to have_content CollectedShift.first.started_at.strftime("%H:%M")
  end

  it "updates collected_shifts" do
    expect(page).to have_content collected_shift.started_at.strftime("%H:%M")

    within ".has-events" do
      find("a").click
    end

    expect(current_path).to eq edit_collected_shift_path(collected_shift)

    fill_in "collected_shift_started_at", with: Time.current + 1.hour

    click_button "変更を保存する"

    expect(current_path).to eq user_path(user)
    expect(page).to have_content "シフトを更新しました"
    # テスト中での時間差が影響しないよう分単位で比較
    expect(collected_shift.started_at.strftime("%H:%M")).to eq Time.current.strftime("%H:%M")
  end

  it "deletes collected_shifts", js: true do
    visit edit_collected_shift_path(collected_shift)

    expect do
      click_link "削除する"
      page.driver.browser.switch_to.alert.accept

      expect(current_path).to eq user_path(user)
      expect(page).to have_content "シフトを削除しました"
    end.to change(CollectedShift, :count).by(-1)
  end
end
