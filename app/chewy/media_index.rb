class MediaIndex < Chewy::Index

  define_type Anime.with_attached_cover.includes(:genres, :tags) do
    root date_detection: false do
      include IndexTranslatable

      translatable_field :titles

      field :desc
      field :sub_titles, type: 'string'
      field :season, :status, type: 'string'
      field :year, :season_year, type: 'short'
      field :started_at, :ended_at, type: 'date'
      field :age_rating, :show_type, type: 'string'

      field :tags, value: ->(a) { a.tags.map(&:name) }
      field :genres, value: ->(a) { a.genres.map(&:name) }
    end
  end
end
