require 'rails_helper'

RSpec.describe 'Attendances', type: :system do
  let(:user) { create(:user) }
  let!(:attendance) { create(:attendance, user: user) }

  before do
    sign_in user
    visit user_path(user)
  end

  it 'creates attendances', js: true do
    click_button '勤怠を入力する'

    expect do
      fill_in 'attendance_started_at', with: Time.current.ago(1.day)
      fill_in 'attendance_finished_at', with: Time.current.ago(1.day).since(1.hour)

      within('#attendance-modal-area') { click_button '提出' }
      expect(page).to have_content '勤怠を確定しました'
    end.to change(Attendance, :count).by(1)

    visit user_path(user)

    expect(page).to have_content Attendance.last.started_at.strftime('%m/%d %H:%M')
    expect(page).to have_content Attendance.last.finished_at.strftime('%H:%M')
  end

  it 'updates attendances' do
    find('.attendance-list').click

    expect(current_path).to eq edit_attendance_path(attendance)
    expect do
      Time.strptime(find('#attendance_started_at').value, '%Y-%m-%dT%H:%M:%S').strftime('%m/%d %H:%M').
        to eq attendance.started_at.strftime('%m/%d %H:%M')
    end

    fill_in 'attendance_started_at', with: Time.current.ago(1.day).ago(1.hour)
    click_button '変更する'

    expect(current_path).to eq user_path(user)
    expect(page).to have_content '勤怠を変更しました'
    expect(attendance.reload.started_at.strftime('%H')).to eq Time.current.ago(1.hour).strftime('%H')
  end

  it 'deletes attendances', js: true do
    visit edit_attendance_path(attendance)

    expect do
      click_link '削除する'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content '勤怠を削除しました'
      expect(current_path).to eq user_path(user)
    end.to change(Attendance, :count).by(-1)
  end
end
