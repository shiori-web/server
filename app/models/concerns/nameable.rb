module Nameable
  extend ActiveSupport::Concern

  included do
    validates :name,
      presence: true,
      uniqueness: true,
      length: { maximum: 100 }
  end
end
