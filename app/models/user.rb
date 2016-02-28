class User < ActiveRecord::Base
  acts_as_taggable_on :skills

  devise :database_authenticatable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :omniauthable

  has_many :authentication_tokens
  has_many :identities

  scope :mentors, -> { where(mentor: true) }
  scope :mentorees, -> { where(mentor: false) }

  def to_s
    user_name
  end

  def unify
    self.mentor ? self.find_related_skills.mentorees : self.find_related_skills
  end

  def password_required?
    identities.empty? && super
  end

  def self.from_omniauth(auth)
    new do |new_user|
      new_user.user_name = auth['info']['name']
      new_user.email = auth['info']['email']
    end
  end
end
