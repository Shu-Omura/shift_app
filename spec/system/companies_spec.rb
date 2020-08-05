require 'rails_helper'

RSpec.describe 'Companies', type: :system do
  let(:user) { create(:user, company: nil) }
  let(:admin_user) { create(:admin_user, company: company) }
  let!(:company) { create(:company) }

  context 'as new user' do
    before do
      sign_in user
      visit edit_user_registration_path
    end

    it 'creates company as owner' do
      within('header') { expect(page).not_to have_link '会社：company' }
      expect(page).to have_link '所属を登録する'
      click_link '所属を登録する'

      expect(page).to have_content '所属会社を登録'
      expect(page).to have_link '管理者の方はこちら'
      click_link '管理者の方はこちら'

      expect(current_path).to eq new_company_path

      expect do
        fill_in '会社名', with: 'company'
        click_button '登録する'

        expect(page).to have_content '会社を新規登録しました。認証キーを従業員に配布してください'
        expect(page).to have_content Company.last.auth_token
        expect(current_path).to eq user_path(user)
      end.to change(Company, :count).by(1)

      expect(page).to have_link '会社：company'
      click_link '会社：company'

      expect(current_path).to eq company_path(Company.last)
    end

    it 'registrates company' do
      expect(page).to have_content '会社：未登録'
      click_link '所属を登録する'

      fill_in '会社名', with: company.name
      fill_in '認証キー', with: company.auth_token
      click_button '申請する'

      expect(page).to have_content 'アカウント情報を変更しました。'
      expect(current_path).to eq user_path(user)
      expect(user.reload.company).to eq company

      expect(page).to have_content "会社：#{company.name}"
      expect(page).not_to have_link "会社：#{company.name}"
    end
  end

  context 'as admin user' do
    before do
      sign_in admin_user
      visit company_path(company)
    end

    it 'updates company info', js: true do
      expect(page).to have_link company.name
      expect(page).to have_content company.auth_token
      expect(page).to have_button 'トークン再生性'
      click_link company.name

      expect(current_path).to eq edit_company_path(company)
      expect(page).to have_field '会社名', with: company.name

      fill_in '住所', with: '東京都'
      click_button '更新する'

      expect(page).to have_content '会社情報を更新しました'
      expect(current_path).to eq company_path(company)
      expect(company.reload.address).to eq '東京都'

      click_button 'トークン再生性'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content '認証キーを再生性しました'
      expect(company.auth_token).not_to eq company.reload.auth_token
    end
  end
end
