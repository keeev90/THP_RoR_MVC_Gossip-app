class Tag < ApplicationRecord
  has_many :gossip_tag_joins
  has_many :gossips, through: :gossip_tag_joins
end
