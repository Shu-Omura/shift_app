module Admin
  class UsersController < ApplicationController
    before_action :admin_user

    def edit
      @user = User.find(params[:id])
    end

    def update
      user = User.find(params[:id])
      if user.update(user_params)
        redirect_to users_path, flash: { success: 'ユーザー情報を更新しました' }
      else
        render 'edit'
      end
    end

    private

    def user_params
      params.require(:user).permit(:admin, :base_salary)
    end
  end
end
