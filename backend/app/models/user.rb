class User < ApplicationRecord
    before_save { self.email = email.downcase }
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
    }
end
