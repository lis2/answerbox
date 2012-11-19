class QuestionsController < ApplicationController
  before_filter :authenticate_user!, except: [:index,:show]

  def index
    @questions = Question.all
  end
  
  def new
    @question = current_user.questions.build
  end

  def create
    @question = current_user.questions.build(params[:question])
    if @question.save
      flash[:info] = "Question was saved"
      redirect_to @question
    else
      flash[:error] = "Something was wrong"
      render "new"
    end
  end

  def show
    @question = Question.find(params[:id])
    @owner = current_user ? @question.owner?(current_user) : false
  end
end
