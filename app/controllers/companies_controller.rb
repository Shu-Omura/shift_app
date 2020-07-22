class CompaniesController < ApplicationController
  before_action :admin_user, only: [:show, :edit, :update, :regenerate]
  before_action :correct_user, only: [:show, :edit, :update]
  before_action :check_company, only: [:new, :create]

  def show
    @company = Company.find(params[:id])
  end

  def new
    @company = current_user.build_company
  end

  def create
    @company = current_user.build_company(company_params)
    if @company.save
      current_user.update(admin: true)
      redirect_to current_user, flash: {success: '会社を新規登録しました。認証キーを従業員に配布してください',
                                           info: "認証キーは `#{@company.auth_token}` です。会社情報より確認できます"}
    else
      render 'new'
    end
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    company = Company.find(params[:id])
    if company.update(company_params_without_name)
      redirect_to company, flash: {success: '会社情報を更新しました'}
    else
      render 'edit'
    end
  end

  def regenerate
    company = Company.find(params[:id])
    company.regenerate_auth_token
    redirect_to company, flash: {success: '認証キーを再生性しました'}
  end

  private

  def company_params
    params.require(:company).permit(:name, :address, :tel)
  end

  def company_params_without_name
    params.require(:company).permit(:address, :tel)
  end
  
  def check_company
    if current_user.company
      redirect_to current_user, flash: {danger: '既に会社情報は登録済みです'}
    end
  end

  def correct_user
    company = Company.find(params[:id])
    if company.nil? || (company != current_user.company)
      redirect_to root_url
    end
  end
end
