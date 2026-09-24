class User < ApplicationRecord
    ROLES = %w[user uploader admin].freeze

    has_secure_password :password, validations: true

    has_many :pages, dependent: :destroy
    has_many :activity_logs, dependent: :destroy

    normalizes :email, with: ->(email) { email.strip.downcase }

    validates :email, presence: true, uniqueness: { case_sensitive: false }
    validates :password, length: { minimum: 12 }, allow_nil: true
    validates :password, confirmation: true, on: :create

    validates :role, inclusion: { in: ROLES }

    def admin?
        role == "admin"
    end

    def uploader?
        role == "uploader"
    end

    def normal_user?
        role == "user"
    end
end
