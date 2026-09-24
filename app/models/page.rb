class Page < ApplicationRecord
  belongs_to :user
  has_many :content_items, dependent: :destroy
  has_one_attached :image
  accepts_nested_attributes_for :content_items, reject_if: :all_blank

  validates :title, presence: true
end
