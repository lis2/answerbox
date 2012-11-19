class QuestionsController < ApplicationController
  before_filter :authenticate_user!, except: "index"

  def index
    @questions = Question.all
  end

  def create
    if @user.questions.create(params[:question])
      flash[:notice] = "Question was saved"
      redirect_to root_path
    else
      flash[:notice] = "Something was wrong"
      render "new"
    end
  end

  def show
    @question = current_user.questions.find(params[:id])
    @owner = @question.owner?(current_user)
  end
end
