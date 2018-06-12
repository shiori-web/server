class AnimePolicy < ApplicationPolicy
  NON_UPDATABLE_FIELDS = %i[
    title status year season_year
    season cover_url small_cover_url
  ].freeze

  NON_VIEWABLE_FIELDS = %i[
    base64_cover base64_cover_filename
  ].freeze

  def fetchable_fields(all)
    all - NON_VIEWABLE_FIELDS
  end

  def creatable_fields(all)
    all - NON_UPDATABLE_FIELDS
  end

  def updatable_fields(all)
    creatable_fields(all)
  end
end
