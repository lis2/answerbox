class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  default_scope :order => 'created_at ASC'

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable
  attr_accessible :comment

  # NOTE: Comments belong to a user
  belongs_to :user
  belongs_to :answer

  validates :comment, presence: true
  validate :time_limit

  def time_limit
    comment = self.commentable.comments.delete_if {|comment| comment.user != self.user}.last
    errors[:comment] << "You have already commented less that one minute ago" if comment && (Time.now - comment.created_at).seconds < 60
  end
end
