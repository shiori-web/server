class AnimeResource < MediaResource
  index MediaIndex::Anime

  attributes :episode_duration, :show_type, :adaptation

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

  query :season,
    valid: ->(value, _opts) {
      value =~ /\A(\w+)-(\d{4})\z/
    },
    apply: ->(values, _context) {
      season, year = values[0].match(/\A(\w+)-(\d{4})\z/).captures
      {
        bool: {
          must: [
            { match: { season: season } },
            { match: { season_year: year } }
          ]
        }
      }
    }

  query :status

  has_many :casts
  has_many :staffs
  has_many :producers
  has_many :anime_producers
end
