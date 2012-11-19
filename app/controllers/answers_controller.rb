class AnswersController < ApplicationController
  before_filter :authenticate_user!, except: "index"
  before_filter :load_answer, only: "mark_as_checked"

  def create
    @question = Question.find(params[:question_id])
    if @question.answers.create(params[:answer])
      flash[:notice] = "Thank you for your answer"
      redirect_to root_path
    else
      flash[:notice] = "Please check if fields are correct"
      redirect_to question_path(@question)
    end
  end

  def mark_as_checked
    @answer.mark_as_checked!
    flash[:notice] = "Answer was checked"
    redirect_to question_path(@answer.question)
  end

  private
  def load_answer
    @answer = Answer.find(params[:id])
    if current_user.id != @answer.question.user_id
      flash[:notice] = "You are not owner of a question"
      redirect_to root_path
    end
  end
end
