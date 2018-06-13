module Seasonal
  extend ActiveSupport::Concern

  included do
    scope :season, ->(season) do
      where('EXTRACT(MONTH FROM started_at) IN (?)', season_to_months(season))
    end

    scope :year, ->(year) do
      where('EXTRACT(YEAR FROM started_at) IN (?)', year)
    end

    %i[spring summer fall].each do |season|
      scope season, ->(year) do
        self.season(season).year(year)
      end
    end

    scope :winter, ->(year) do
      months = season_to_months(:winter) - [12]
      sql = 'EXTRACT(MONTH FROM started_at) IN (?)'

      where(sql, months).year(year).or(
        where(sql, [12]).year(year - 1)
      )
    end
  end

  class_methods do
    def month_to_season(month)
      case month
      when 12, 1, 2 then :winter
      when 3, 4, 5 then :spring
      when 6, 7, 8 then :summer
      when 9, 10, 11 then :fall
      end
    end

    def season_to_months(season)
      case season.try(:to_sym)
      when :winter then [12, 1, 2]
      when :spring then [3, 4, 5]
      when :summer then [6, 7, 8]
      when :fall then [9, 10, 11]
      end
    end
  end

  def year
    started_at.try(:year)
  end

  def season
    self.class.month_to_season(started_at.try(:month))
  end

  def season_year
    started_at.try(:month) == 12 ? year + 1 : year
  end
end
