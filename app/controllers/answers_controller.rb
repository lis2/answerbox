class AnswersController < ApplicationController
  before_filter :authenticate_user!, except: "index"
  before_filter :load_answer, only: "mark_as_checked"

  def create
    @question = Question.find(params[:question_id])
    if @answer = @question.answers.create(params[:answer])

      @answer.update_attribute(:user_id, current_user.id)

      rendered_content = render_to_string(:partial => "questions/answer",:layout => false,:locals => {:answer => @answer})
      Notifier.instance.broadcast_message("/questions/#{@question.id}",{:fresh_answer => rendered_content})

      flash[:notice] = "Thank you for your answer"
    else
      flash[:notice] = "Please check if fields are correct"
    end
    redirect_to question_path(@question)
  end

  def mark_as_checked
    @answer.mark_as_answered!
    flash[:notice] = "Answer was checked"
    redirect_to question_path(@answer.question)
  end

  private
  def load_answer
    @answer = Answer.find(params[:id])
    unless @answer.question.owner?(current_user)
      flash[:notice] = "You are not owner of a question"
      redirect_to root_path
    end
  end
end
