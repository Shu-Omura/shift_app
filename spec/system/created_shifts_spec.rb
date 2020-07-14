require 'rails_helper'

RSpec.describe 'CreatedShifts', type: :system do
  let(:admin_user) { create(:admin_user) }
  let!(:collected_shift) { create(:collected_shift) }

  before { sign_in admin_user }

  it 'creates created_shifts as admin_user', js: true do
    visit root_path

    expect(page).to have_content '確定シフト'

    click_link '社員シフト一覧'

    expect(page).to have_content collected_shift.user.name
    expect(page).to have_content collected_shift.started_at.strftime('%H:%M')

    expect do
      within '.has-events' do
        find('a').click
      end
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content 'シフトを確定させました'
    end.to change(CreatedShift, :count).by(1)

    visit created_shifts_path

    expect(page).to have_content collected_shift.started_at.strftime('%H:%M')
    expect(page).to have_content CreatedShift.last.started_at.strftime('%H:%M')
  end

  it 'deletes created_shifts as admin_user', js: true do
    created_shift = create(:created_shift)
    visit created_shifts_path

    expect(page).to have_content created_shift.started_at.strftime('%H:%M')
    expect do
      within '.has-events' do
        find('a').click
      end
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content 'シフトを未確定に変更しました'
    end.to change(CreatedShift, :count).by(-1)

    visit created_shifts_path

    expect(page).not_to have_content created_shift.started_at.strftime('%H:%M')
  end
end
