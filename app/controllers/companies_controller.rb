class CompaniesController < ApplicationController
  def show
    @company = Company.find(params[:id])
  end

  def new
    if current_user.company
      redirect_to current_user, flash: {danger: '既に会社情報は登録済みです'}
    else
      @company = current_user.build_company
    end
  end

  def create
    @company = current_user.build_company(company_params)
    if @company.save
      current_user.update(admin: true)
      redirect_to current_user, flash: {success: '会社を新規登録しました。認証キーを従業員に配布してください。',
                                           info: "認証キーは `#{@company.auth_token}` です。会社情報より確認できます。"}
    else
      render 'new'
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :address, :tel)
  end
end
