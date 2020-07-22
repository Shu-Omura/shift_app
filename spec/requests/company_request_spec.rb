require 'rails_helper'

RSpec.describe 'Companies', type: :request do
  let(:admin_user) { create(:admin_user, company: company) }
  let(:user) { create(:user, company: company) }
  let(:company) { create(:company) }
  let(:company_params) { attributes_for(:company, address: '東京都') }

  describe 'GET #show' do
    context 'as admin user' do
      before do
        sign_in admin_user
        get company_path(company)
      end

      it { expect(response).to have_http_status(200) }

      it 'shows company info' do
        expect(response.body).to include company.name
      end
    end

    context 'as general user' do
      before do
        sign_in user
        get company_path(company)
      end

      it { expect(response).to have_http_status(302) }
      it { expect(response).to redirect_to root_url }
    end
  end
  
  describe 'GET #new' do
    context 'as already registrated user' do
      before do
        sign_in user
        get new_company_path
      end

      it { expect(response).to have_http_status(302) }
      it { expect(response).to redirect_to user }
    end

    context 'as not registared user' do
      let(:user_2) { create(:user, company: nil) }

      before do
        sign_in user_2
        get new_company_path
      end

      it { expect(response).to have_http_status(200) }
    end
  end

  describe 'POST #create' do
    subject { post companies_path, params: { company: company_params } }

    context 'as already registrated user' do
      before { sign_in user }

      it { is_expected.to eq 302 }
      it { is_expected.to redirect_to user }
      it { expect { subject }.not_to change(Company, :count) }
    end

    context 'as not registared user' do
      let(:user_2) { create(:user, company: nil) }
      
      before { sign_in user_2 }

      it { is_expected.to eq 302 }
      it { is_expected.to redirect_to user_2 }
      it { expect { subject }.to change(Company, :count).by(1) }
      it 'updates user admin attribute' do
        subject
        expect(user_2.admin?).to be true
      end

      it 'creates auth_toke' do
        subject
        expect(Company.last.auth_token).not_to be nil
      end
    end
  end

  describe 'GET #edit' do
    context 'as admin user' do
      before do 
        sign_in admin_user
        get edit_company_path(company)
      end

      it { expect(response).to have_http_status(200) }
      it { expect(response.body).to include company.name }
    end

    context 'as general user' do
      before do 
        sign_in user
        get edit_company_path(company)
      end

      it { expect(response).to have_http_status(302) }
      it { expect(response).to redirect_to root_url }
    end
  end

  describe 'PUT #update' do
    subject { put company_path(company), params: { company: company_params } }

    context 'as admin user' do
      before { sign_in admin_user }

      it { is_expected.to eq 302 }
      it { is_expected.to redirect_to company }
      it 'updates company' do
        subject
        expect(company.reload.address).to eq '東京都'
      end
    end

    context 'as general user' do
      before { sign_in user }

      it { is_expected.to eq 302 }
      it { is_expected.to redirect_to root_url }
      it 'is not updated company' do
        subject
        expect(company.reload.address).not_to eq '東京都'
      end
    end
  end

  describe 'POST #regenerate' do
    let!(:auth_token) { company.auth_token }
    subject { post regenerate_company_path(company) }

    context 'as admin user' do
      before { sign_in admin_user }

      it { is_expected.to eq 302 }
      it { is_expected.to redirect_to company }
      it 'updates auth_token' do
        subject
        expect(company.reload.auth_token).not_to eq auth_token
      end
    end

    context 'as general user' do
      before { sign_in user }

      it { is_expected.to eq 302 }
      it { is_expected.to redirect_to root_url }
      it 'is not updated auth_token' do
        subject
        expect(company.reload.auth_token).to eq auth_token
      end
    end
  end
end
