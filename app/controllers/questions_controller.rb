class QuestionsController < ApplicationController
  def new
  end

  def create
    if @user.questions.create!(params[:question])
      flash[:notice] = "Question was saved"
      redirect_to root_path
    else
      flash[:notice] "Something was wrong"
      render "new"
    end
  end
end
