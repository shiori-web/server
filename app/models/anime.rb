class Anime < ApplicationRecord
  include Media
  include AgeRatings

  enum status: %i[TBA Upcoming Ongoing Finished].freeze
  enum show_type: %i[NA TV Movie OVA ONA Special Music].freeze
end
