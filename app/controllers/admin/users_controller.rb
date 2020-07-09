module Admin
  class UsersController < ApplicationController
    before_action :admin_user

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        flash[:success] = "ユーザー情報を更新しました"
        redirect_to users_path
      else
        render "edit"
      end
    end

    private

    def user_params
      params.require(:user).permit(:master, :base_salary)
    end
  end
end