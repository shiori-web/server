class CastResource < BaseResource
  attributes :role, :locale

  filter :anime_id

  belongs_to :person
  belongs_to :character
end
