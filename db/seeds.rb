ApplicationRecord.transaction do
  # import genres
  genres = File.read(Rails.root.join('db/genres.txt').to_s)
    .split('|').map { |name| Genre.new(name: name) }
  Genre.import!(genres)

  # import producers
  producers = File.read(Rails.root.join('db/producers.txt').to_s)
    .split('|').map { |name| Producer.new(name: name) }
  Producer.import!(producers)
end
