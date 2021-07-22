class User < ApplicationRecord
    before_save { self.email = email.downcase }
    validates :name,  presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                        format: { with: VALID_EMAIL_REGEX },
                        uniqueness: { case_sensitive: false }
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
      end
end
