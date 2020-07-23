require 'rails_helper'

RSpec.describe 'CollectedShifts', type: :system do
  let(:user) { create(:user) }
  let!(:collected_shift) { create(:non_determined, user: user) }

  before do
    sign_in user
    visit user_path(user)
  end

  it 'creates collected_shifts' do
    expect do
      fill_in 'collected_shift_started_at', with: Time.current
      fill_in 'collected_shift_finished_at', with: Time.current.since(1.hour)
      click_button '提出'

      expect(page).to have_content 'シフトを提出しました'
    end.to change(CollectedShift, :count).by(1)
    
    visit user_path(user)

    expect(page).to have_content CollectedShift.count
    expect(page).to have_content CollectedShift.first.started_at.strftime('%H:%M')
  end

  it 'updates collected_shifts' do
    expect(page).to have_content collected_shift.started_at.strftime('%H:%M')
    within('.has-events') { find('a').click }

    expect(current_path).to eq edit_collected_shift_path(collected_shift)

    fill_in 'collected_shift_started_at', with: Time.current.since(10.hour)
    click_button '変更する'

    expect(current_path).to eq user_path(user)
    expect(page).to have_content 'シフトを更新しました'
    # テスト中での時間差が影響しないよう分単位で比較
    expect(collected_shift.reload.started_at.strftime('%H'))
      .to eq Time.current.since(10.hour).strftime('%H')
  end

  it 'deletes collected_shifts', js: true do
    visit edit_collected_shift_path(collected_shift)

    expect do
      click_link '削除する'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content 'シフトを削除しました'
      expect(current_path).to eq user_path(user)
    end.to change(CollectedShift, :count).by(-1)
  end
end
