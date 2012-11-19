class Question < ActiveRecord::Base
  attr_accessible :body, :title, :user_id
  
  belongs_to :user
  has_many :answers

  validates :title, presence: true, length: { in: 10..150 }
  validates :body, presence: true, length: { minimum: 1 }

  def answered?
    self.answers.detect(&:answered?)
  end

  def owner?(current_user)
    self.user_id == current_user.id
  end
end
