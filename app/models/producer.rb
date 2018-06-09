class Producer < ApplicationRecord
  belongs_to :anime
  belongs_to :company

  delegate :name, :info, to: :company
end
