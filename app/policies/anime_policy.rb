class AnimePolicy < ApplicationPolicy
  NON_UPDATABLE_FIELDS = %i[
    title status year
    season season_year
  ].freeze

  def fetchable_fields(all)
    all - [:genres]
  end

  def creatable_fields(all)
    all - NON_UPDATABLE_FIELDS
  end

  def updatable_fields
    creatable_fields
  end
end
