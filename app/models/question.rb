class Question < ActiveRecord::Base
  attr_accessor   :tags_list
  attr_accessible :body, :title, :user_id, :tags_list
  
  belongs_to :user
  has_many :answers
  has_and_belongs_to_many :tags

  validates :title, presence: true, length: { in: 10..150 }
  validates :body, presence: true, length: { minimum: 1 }

  validate :user_can_ask_question

  COST = 1

  def answered?
    self.answers.detect(&:answered?)
  end

  def owner?(current_user)
    self.user_id == current_user.id
  end

  before_save :render_body

  before_create :create_tags

  after_create :remove_points

  scope :with_tag, lambda { |tag_name| joins(:tags).where("tags.name = ?", tag_name) }

  private
  def user_can_ask_question
    self.errors[:cannot_ask] << "Not enough points to ask a question" unless self.user.can_ask_question?
  end

  def remove_points
    self.user.points -= COST
    self.user.save
  end

  def render_body
    renderer = Redcarpet::Render::HTML.new
    extensions = {fenced_code_blocks: true}
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    self.body = redcarpet.render(self.body)
  end

  def create_tags
    tags_names = self.tags_list.split(",")
    tags_names.each do |tag_name|
      tag_name = tag_name.strip
      tag = Tag.find_or_create_by_name(tag_name)
      self.tags << tag
    end
  end
end
