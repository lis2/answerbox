class QuestionsController < ApplicationController
  before_filter :authenticate_user!, except: :index

  def index
    @questions = Question.all
  end
  
  def new
    @question = current_user.questions.build
  end

  def create
    @question = current_user.questions.build(params[:question])
    if @question.save
      flash[:notice] = "Question was saved"
      redirect_to @question
    else
      flash[:notice] = "Something was wrong"
      render "new"
    end
  end

  def show
    @question = current_user.questions.find(params[:id])
  end
end
