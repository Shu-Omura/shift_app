class WorkingResultsController < ApplicationController
  
  def index
    @users = User.colleagues(current_user)
    @all_terms = WorkingResult.all_terms.sort.reverse
    @term = params[:term] || Time.current.strftime("%Y/%m")
  end
end
