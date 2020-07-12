class CompaniesController < ApplicationController

  def show
    @company = Company.find(params[:id])
  end

  def new
    unless current_user.company
      @company = current_user.build_company
    else
      flash[:danger] = "既に会社情報は登録済みです"
      redirect_to current_user
    end
  end

  def create
    @company = current_user.build_company(company_params)
    if @company.save
      current_user.update(admin: true)
      flash[:success] = "会社を新規登録しました。認証キーを従業員に配布してください。"
      flash[:info] = "認証キーは `#{@company.auth_token}` です。会社情報より確認できます。"
      redirect_to current_user
    else
      render "new"
    end    
  end

  private

  def company_params
    params.require(:company).permit(:name, :address, :tel)
  end
end
