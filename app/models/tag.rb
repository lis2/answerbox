class Tag < ActiveRecord::Base
  attr_accessible :title, :body
  has_and_belongs_to_many :questions
  validates :name, presence: true, uniqueness: true
end
