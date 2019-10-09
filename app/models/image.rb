class Image < ApplicationRecord
  belongs_to :item
  validates :item_id, presence: true
  mount_uploader :image, ImageUploader
end