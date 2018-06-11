class MangaResource < BaseResource
  FIELDS = %i[
    titles slug desc started_at
    ended_at subtype age_rating
    age_rating_guide sub_titles
  ].freeze

  VIRTUAL_FIELDS = %i[
    season year season_year status
    cover_url small_cover_url title
    base64_cover base64_cover_filename
  ].freeze

  attributes *(FIELDS + VIRTUAL_FIELDS)

  has_many :tags
  has_many :genres
  has_many :authors
  has_many :publishers
  has_many :characters
  has_many :manga_characters
end
