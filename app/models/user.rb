class User < ActiveRecord::Base
  has_many :tweets, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: 'Relationship', dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates_confirmation_of :password, if: -> (m) { m.password.present? }
  validates :password, length: { minimum: 6 }
  validates :slug, uniqueness: true

  def to_param
    slug
  end

  def feed
    r = Relationship.arel_table
    t = Tweet.arel_table
    sub_query = t[:user_id].in(r.where(r[:follower_id].eq(id)).project(r[:followed_id]))
    Tweet.where(sub_query.or(t[:user_id].eq(id)))
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end
end