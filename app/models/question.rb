class Question < ActiveRecord::Base
  attr_accessible :body, :title, :user_id
  
  belongs_to :user
  has_many :answers

  validates :title, presence: true, length: { in: 10..150 }
  validates :body, presence: true, length: { minimum: 1 }

  def answered?
    self.answers.detect(&:answered?)
  end

  before_save :render_body

  private
  def render_body
    renderer = Redcarpet::Render::HTML.new
    extensions = {fenced_code_blocks: true}
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    self.body = redcarpet.render(self.body)
  end
end
