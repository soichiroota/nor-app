class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
    foreign_key: "follower_id",
    dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                        format: { with: VALID_EMAIL_REGEX },
                        uniqueness: { case_sensitive: false }
                        has_secure_password validations: false
  validates :password, # 半角英数字を各一文字以上含む6-100文字の文字列
                        format: {
                            with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{6,100}+\z/i,
                            message: 'は英数6文字以上で指定してください。'
                        },
                        presence: true, length: { minimum: 6 }, allow_nil: true
  has_secure_password validations: false
  has_secure_token

  def available_token?
    token_expired_at && token_expired_at > Time.current
  end
    
  def token_refresh!
    _, t = TokenGenerator.generate(User, 'token')
    self.update!(token: t, token_expired_at: User.token_expires)
  end

  # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
    
  class << self
    def token_expires
      3.hours.since
    end
    
    def generate_password
      # 半角英数字を各一文字以上含む6-100文字の文字列
      s = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      n = [('0'..'9')].map { |i| i.to_a }.flatten
    
      string_part = (0...8).map { s[rand(s.length)] }.join
      number_part = (0...8).map { n[rand(n.length)] }.join
    
      string_part + number_part
    end

    # 渡された文字列のハッシュ値を返す
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                        BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
          
    # ランダムなトークンを返す
    def new_random_token
      SecureRandom.urlsafe_base64
    end
  end
  
  # アカウントを有効にする
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end
  
  # 有効化用のメールを送信する
  def send_activation_email(url, is_base_url)
    UserMailer.account_activation(self, url, is_base_url).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_random_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  # パスワード再設定のメールを送信する
  def send_password_reset_email(url, is_base_url)
    UserMailer.password_reset(self, url, is_base_url).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # ユーザーのステータスフィードを返す
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end
  
  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  
  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  def microposts_count
    microposts.count
  end

  def following_count
    following.count
  end

  def followers_count
    followers.count
  end

  private

  # メールアドレスをすべて小文字にする
  def downcase_email
    self.email = email.downcase
  end

  # 有効化トークンとダイジェストを作成および代入する
  def create_activation_digest
    self.activation_token  = User.new_random_token
    self.activation_digest = User.digest(activation_token)
  end
end
