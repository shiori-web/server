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

  filter :year,
    verify: ->(values, _context) {
      value = values[0]
      return [] unless value

      if value =~ /\A\d+(\.\.\d+)?\z/
        range = value.split('..').map(&:to_i)
        range.size > 1 ? Range.new(*range).to_a : range
      else
        []
      end
    },
    apply: ->(records, values, _context) {
      records.year(values)
    }

  filter :season, apply: ->(records, values, _context) {
    %w[winter spring summer fall].include?(values[0]) ?
      records.season(values[0]) : records.none
  }

  has_many :casts
  has_many :characters
  has_many :genres
  has_many :producers
  has_many :anime_producers
  has_many :staffs
  has_many :tags
end
