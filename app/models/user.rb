class User < ApplicationRecord
  rolify
  after_create :assign_default_role
  has_many :identities
  has_many :ratings
  has_many :quotes, through: :ratings
  has_many :viewed_quotes
  has_many :quotes, through: :viewed_quotes
  enum strategy: [ :random, :strategy1, :strategy2 ]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  def assign_default_role
    add_role :user
  end

  def self.from_omniauth(access_token, current_user)
    data = access_token.info
    identity = Identity.where(provider: access_token.provider,
                              uid: access_token.uid).first_or_initialize

    if identity.user.blank?
      user = current_user || User.where(email: data['email']).first

      if user.blank?
        user = User.create(
          name: data['name'],
          email: data['email'],
          password: Devise.friendly_token[0, 20]
        )
      end

      identity.user = user
      identity.save!
    end
    identity.user
  end
end
