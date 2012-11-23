class Question < ActiveRecord::Base

  attr_accessor   :tags_list
  attr_accessible :body, :title, :user_id, :tags_list,:rendered_body

  belongs_to :user
  has_many :answers,:dependent => :destroy
  has_and_belongs_to_many :tags

  validates :title, presence: true, length: { in: 10..150 }
  validates :body, presence: true, length: { minimum: 1 }

  validate :user_can_ask_question
  validate :user_needs_to_wait_5_minutes

  before_save :render_body
  before_create :create_tags
  after_create :remove_points

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
  def user_needs_to_wait_5_minutes
    seconds_to_wait = 1.minutes
    most_recent_question = self.user.questions.order("created_at DESC").first
    if most_recent_question
      if (Time.now - most_recent_question.created_at).seconds < seconds_to_wait
        errors[:body] << "You need to wait #{seconds_to_wait} seconds before you can ask another question"
      end
    end
  end

  def user_can_ask_question
    self.errors[:body] << "Not enough points to ask a question" unless self.user.can_ask_question?
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
