class QuestionsController < ApplicationController
  before_filter :authenticate_user!, except: [:index,:show]

  def index
    @questions = Question.paginate(:page => params[:page],:per_page => 10)
  end

  def load_data
    @questions = Question.paginate(:page => params[:page],:per_page => 5)
    render :partial => "questions/question",:layout => false,:collection => @questions
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

  def filter
    @questions = Question.with_tag(params[:tag_name])
  end
end
