class Category < ApplicationRecord
  belongs_to :genre
  belongs_to :categorizable, polymorphic: true
end
