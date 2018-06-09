class AnimeResource < BaseResource
  FIELDS = %i[
    title titles slug
    desc cover started_at ended_at
    show_type age_rating age_rating_guide
    adaptation episode_duration sub_titles
    season year season_year status genres
  ]

  attributes *FIELDS

  has_many :characters
  has_many :genres
  has_many :performers
  has_many :producers
  has_many :staffs
  has_many :tags
end
