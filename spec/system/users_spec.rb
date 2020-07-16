require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }
  let(:admin_user) { create(:admin_user, name: 'admin', company: company) }

  describe '#index' do
    before { create_list(:user, 5, company: company) }

    context 'as non_admin' do
      before do
        sign_in user
        visit users_path
      end

      it 'shows all users with no links and no details' do
        expect(page).to have_selector('.staff-lists > li', count: 6)
        expect(page).not_to have_selector('.staff-lists > a')
        expect(page).not_to have_selector('.explanation')

        expect(page).not_to have_content user.email
        expect(page).not_to have_content '一般ユーザー'
        expect(page).not_to have_content user.base_salary 
      end
    end

    context "as admin" do
      before do
        sign_in admin_user
        visit users_path
      end

      it 'shows all users with links and details' do
        expect(page).to have_selector('.staff-profile', count: 6)
        expect(page).to have_link admin_user.name
        expect(page).to have_selector('.explanation')

        expect(page).to have_content admin_user.email
        expect(page).to have_content '管理者'
        expect(page).to have_content admin_user.base_salary

        within 'table' do
          click_link admin_user.name
        end

        expect(current_path).to eq user_path(admin_user)
      end
    end
  end

  describe 'admin#edit' do
    context 'as admin' do
      before do
        sign_in admin_user
        visit users_path
        within 'table' do
          click_link '管理者'
        end
      end

      it 'updates base_salary' do
        expect(current_path).to eq edit_admin_user_path(admin_user)
        expect(page).to have_select('ユーザー区分', selected: '管理者')  
        expect(page).to have_field '基本給', with: 1000

        fill_in '基本給', with: 1200
        click_button '更新する'

        expect(current_path).to eq users_path
        expect(page).to have_content 'ユーザー情報を更新しました'
        expect(page).to have_selector('table'), text: 1200
      end

      it 'updates admin to general user' do
        select '一般ユーザー', from: 'ユーザー区分'
        click_button '更新する'

        expect(current_path).to eq users_path
        expect(page).to have_content 'ユーザー情報を更新しました'

        expect(admin_user.reload.admin).to be false
      end
    end
  end
end