class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:first_name,:last_name
  # attr_accessible :title, :body

  attr_accessible :avatar
  has_attached_file :avatar

  has_many :questions,:dependent => :destroy
  has_many :answers  ,:dependent => :destroy

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    new_user_was_created = false
    actual_user_object   = nil


    data = access_token.extra.raw_info
    if user = User.where(:email => data.email).first
      actual_user_object = user
    else # Create a user with a stub password.

      facebook_picture = nil

      mech = Mechanize.new {|m| m.user_agent_alias = "Mac Safari" }
      mech.get(access_token["info"]["image"].sub(/square/ , "large")) do |page|
        rand_name = SecureRandom.hex(16)
        facebook_picture = AppSpecificStringIO.new("#{rand_name}.jpeg","image/jpeg",page.body)
      end
      
      actual_user_object = User.new(:email => data.email, :password => Devise.friendly_token[6,12],:avatar => facebook_picture,:first_name => data.first_name,:last_name => data.last_name)      
      actual_user_object.save

    end

    actual_user_object

  end

end
