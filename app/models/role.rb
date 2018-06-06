class Role < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_roles

  belongs_to :resource,
    optional: true,
    polymorphic: true

  validates :resource_type,
    allow_nil: true,
    inclusion: { in: Rolify.resource_types }

  scopify
end
