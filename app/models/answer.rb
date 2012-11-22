class Answer < ActiveRecord::Base
  attr_accessible :answered, :body, :question_id, :user_id

  belongs_to :question
  belongs_to :user
  
  validates :body, presence: true, length: { minimum: 1 }
  validate :question_answered
  validate :only_one_answer_per_user_per_question,:on => :create

  before_save :render_body
  after_create :give_points_to_user

  acts_as_commentable
 
  BONUS = 1
  CORRECT_ANSWER_BONUS = 5

  def mark_as_answered!
    self.answered = true
    self.save

    self.user.change_points!(CORRECT_ANSWER_BONUS)
  end

  private
  def give_points_to_user
    self.user.change_points!(BONUS)
  end

  def render_body
    renderer = Redcarpet::Render::HTML.new
    extensions = {fenced_code_blocks: true}
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    self.body = redcarpet.render(self.body)
  end

  def only_one_answer_per_user_per_question
    question = self.question
    already_answered_question = question.answers.find {|e| e.user == self.user }
    errors[:answered] << "You have already answered that question" if already_answered_question
  end

  def question_answered
    errors[:answered] << 'Question releated to this answer is already answered' if self.question.answered?
  end

end
