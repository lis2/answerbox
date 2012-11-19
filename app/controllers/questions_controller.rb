class QuestionsController < ApplicationController
  before_filter :authenticate_user!

  def create
    if @user.questions.create!(params[:question])
      flash[:notice] = "Question was saved"
      redirect_to root_path
    else
      flash[:notice] "Something was wrong"
      render "new"
    end
  end

  def show
    @question = current_user.questions(params[:id])
  end
end
