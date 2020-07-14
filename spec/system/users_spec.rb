require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let!(:user) { create(:fixed_user) }

  it 'signs up' do
    visit root_url
    find('.top-form').click_link '新規登録'

    expect(current_path).to eq new_user_registration_path

    fill_in 'ユーザー名', with: 'sample user'
    fill_in 'メールアドレス', with: 'sample@gmail.com'
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード再入力', with: 'password'

    click_button 'サインアップ'

    expect(page).to have_content 'アカウント登録が完了しました。'
    expect(User.count).to eq(2)
  end

  it 'logs in' do
    visit root_url
    find('.top-form').click_link 'ログイン'

    expect(current_path).to eq new_user_session_path

    fill_in 'メールアドレス', with: 'fixed@user.com'
    fill_in 'パスワード', with: 'foobar'

    click_button 'ログイン'

    expect(page).to have_content 'ログインしました。'
    expect(current_path).to eq user_path(user)
  end

  it 'logs out' do
    sign_in user
    visit user_path(user)

    click_link 'ログアウト'

    expect(page).to have_content 'ログアウトしました。'
    expect(current_path).to eq root_path
  end

  it 'updates name' do
    sign_in user
    visit user_path(user)
    find('.links').click_link 'アカウント設定'

    expect(current_path).to eq edit_user_registration_path
    expect(page).to have_content user.name

    fill_in '現在のパスワードを確認', with: 'foobar'
    fill_in 'ユーザー名', with: 'update name'

    click_button '変更を保存'

    expect(page).to have_content 'アカウント情報を変更しました。'
    expect(current_path).to eq root_path
    expect(user.reload.name).to eq 'update name'
  end
end
