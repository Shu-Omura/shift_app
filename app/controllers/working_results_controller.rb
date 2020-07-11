class WorkingResultsController < ApplicationController
  
  def index
    @users = User.colleagues(current_user)
  end
end
