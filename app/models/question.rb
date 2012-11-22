class Question < ActiveRecord::Base

  attr_accessor   :tags_list
  attr_accessible :body, :title, :user_id, :tags_list,:rendered_body
  
  belongs_to :user
  has_many :answers,:dependent => :destroy
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

  def tags?
    self.tags.present?
  end

  def tags_names
    tags.collect(&:name).join(", ")
  end

  before_save :render_body

  before_create :create_tags

  after_create :remove_points

#  scope :with_tag, lambda { |tag_name| includes(:tags).where("tags.name LIKE ?", "#{tag_name}%") }
  def self.with_tag_or_name(search)
    if search.present?
      #joins(:tags).where("tags.name LIKE ? OR title LIKE ?", "#{search}%", "%#{search}%").uniq
      joins("LEFT JOIN 'questions_tags' on questions.id = questions_tags.question_id LEFT JOIN 'tags' on tags.id = questions_tags.tag_id")
        .where("tags.name LIKE ? or TITLE like ?","%#{search}%","%#{search}%").uniq
    else
      Question.scoped
    end
  end

  private
  def user_can_ask_question
    self.errors[:cannot_ask] << "Not enough points to ask a question" unless self.user.can_ask_question?
  end

  def remove_points
    self.user.change_points!(-COST)
  end

  def render_body
    renderer = Redcarpet::Render::HTML.new
    extensions = {fenced_code_blocks: true}
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    self.rendered_body = redcarpet.render(self.body)
  end

  def create_tags
    if self.tags_list.present?
      tags_names = self.tags_list.split(",")
      tags_names.each do |tag_name|
        tag_name = tag_name.strip
        tag = Tag.find_or_create_by_name(tag_name)
        self.tags << tag
      end
    end
  end
end
