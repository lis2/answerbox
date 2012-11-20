class Answer < ActiveRecord::Base
  attr_accessible :answered, :body, :question_id, :user_id
  belongs_to :question
  belongs_to :user
  
  validates :body, presence: true, length: { minimum: 1 }
  validate :question_answered
 
  def mark_as_answered!
    self.answered = true
    self.save
  end

  before_save :render_body

  private
  def render_body
    renderer = Redcarpet::Render::HTML.new
    extensions = {fenced_code_blocks: true}
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    self.body = redcarpet.render(self.body)
  end

  def question_answered
    errors[:answered] << 'Question releated to this answer is already answered' if self.question.answered?
  end

end
