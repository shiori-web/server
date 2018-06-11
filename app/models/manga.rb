class Manga < ApplicationRecord
  include Media
  include AgeRatings
  include Uploadable

  enum subtype: %i[manga manhwa manhua novel]

  has_many :manga_characters, dependent: :destroy
  has_many :characters, through: :manga_characters
  has_and_belongs_to_many :authors,
    join_table: 'authors', class_name: 'Person'
  has_and_belongs_to_many :publishers,
    join_table: 'publishers', class_name: 'Producer'

  uploadable_field :cover, versions: {
    small: '225x320>'
  }

  validates_presence_of :subtype

  private

  def slug_candidates
    [
      -> { title },
      -> { [title, subtype] },
      -> { [title, subtype, year] }
    ]
  end
end
