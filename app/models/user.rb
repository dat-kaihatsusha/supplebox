# frozen_string_literal: true

class User < ApplicationRecord
  # ユーザー登録用
  before_save { email.downcase! }
  validates :name, presence: true, length: {maximum: 50}
  validates :nickname, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: {maximum: 255},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: 6}, allow_nil: true
  validates :comment, length: {maximum: 100}
  mount_uploader :picture, AvatarUploader

  has_secure_password

  # ページネーションの表示件数追加
  paginates_per 9

  # 口コミ投稿との関連付け
  has_many :posts, dependent: :destroy

  # お問い合わせとの関連付け
  has_many :contacts, dependent: :destroy

  # お気に入り機能追加用中間テーブル追加
  has_many :likes, dependent: :destroy
  has_many :products, through: :likes

  # お気に入り追加
  def like(product)
    likes.find_or_create_by(product_id: product.id)
  end

  # お気に入り削除
  def unlike(product)
    like = likes.find_by(product_id: product.id)
    like&.destroy
  end

  # お気に入り登録判定
  def like?(product)
    products.include?(product)
  end

  # 　フォロー機能追加用中間テーブル
  has_many :relationships, dependent: :destroy
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id', inverse_of: :user, dependent: :destroy
  has_many :followers, through: :reverses_of_relationship, source: :user

  # フォロー登録
  def follow(other_user)
    relationships.find_or_create_by(follow_id: other_user.id) unless self == other_user
  end

  # フォロー削除
  def unfollow(other_user)
    relationship = relationships.find_by(follow_id: other_user.id)
    relationship&.destroy
  end

  # フォロー判定
  def following?(other_user)
    followings.include?(other_user)
  end

  # お気に入り数表示
  def self.ranking
    group(:user.product_id).order('brand_id').count(:user.product_id)
  end
end
