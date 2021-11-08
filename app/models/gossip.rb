class Gossip < ApplicationRecord
  belongs_to :user
  has_many :gossip_tag_joins
  has_many :tags, through: :gossip_tag_joins
  has_many :comments
  has_many :likes

  validates :title, presence: true, length: { in: 3..20 }
  validates :content, presence: true
  validates :user_id, presence: true 
end
