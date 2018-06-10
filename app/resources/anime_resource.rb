class AnimeResource < BaseResource
  FIELDS = %i[
    titles slug desc started_at
    ended_at show_type age_rating
    age_rating_guide adaptation
    episode_duration sub_titles
  ].freeze

  VIRTUAL_FIELDS = %i[
    season year season_year status
    cover_url small_cover_url title
    base64_cover base64_cover_filename
  ].freeze

  attributes *(FIELDS + VIRTUAL_FIELDS)

  has_many :characters
  has_many :genres
  has_many :performers
  has_many :producers
  has_many :staffs
  has_many :tags
end
