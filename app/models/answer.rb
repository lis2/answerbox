class Answer < ActiveRecord::Base
  attr_accessible :answered, :body, :question_id, :user_id
  belongs_to :question
  belongs_to :user
  
  validates :body, presence: true
  validate :question_answered

  def mark_as_answered!
    self.answered = true
    self.save
  end

  private
  def question_answered
    errors[:answered] << 'Question releated to this answer is already answered' if self.question.answered?
  end
end
