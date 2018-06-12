namespace :mal do
  MAL_DIR = Rails.root.join('db/data/mal').to_s
  LOCALES = {
    'Japanese' => 'jp',
    'English' => 'en'
  }

  desc 'MyAnimeList import!'
  task :import, [:from, :to] => :environment do |t, args|
    from = args[:from].to_i
    to = args[:to].to_i

    Rake::Task['mal:combine'].invoke(from, to)

    ApplicationRecord.transaction do
      filename = "#{from}-#{to}.json"

      people_map = {}
      people_path = File.join(MAL_DIR, "people/#{filename}")
      people_info = JSON.parse(File.read(people_path))
      people = people_info.keys.sort.map do |key|
        name = people_info[key]
        next if name.blank?
        person = Person.new(name: name)
        people_map[key] = person
        person
      end.compact

      characters_map = {}
      characters_path = File.join(MAL_DIR, "characters/#{filename}")
      characters_info = JSON.parse(File.read(characters_path))
      characters = characters_info.keys.sort.map do |key|
        name = characters_info[key]
        next if name.blank?
        character = Character.new(name: name)
        characters_map[key] = character
        character
      end.compact

      Person.import! people
      Character.import! characters

      animes_path = File.join(MAL_DIR, "animes/#{filename}")
      animes_info = JSON.parse(File.read(animes_path))
      animes = animes_info.map do |anime_info|
        anime = Anime.new(get_anime_info(anime_info))

        anime_producers = Producer.where(name: anime_info['producers'])
        anime_producers.each do |anime_producer|
          anime.anime_producers.build(producer_id: anime_producer.id, role: 'producer')
        end

        anime_studios = Producer.where(name: anime_info['studios'])
        anime_studios.each do |anime_studio|
          anime.anime_producers.build(producer_id: anime_studio.id, role: 'studio')
        end

        anime_licensors = Producer.where(name: anime_info['licensors'])
        anime_licensors.each do |anime_licensor|
          anime.anime_producers.build(producer_id: anime_licensor.id, role: 'licensor')
        end

        anime_genres = Genre.where(name: anime_info['genres'])
        anime_genres.each do |genre|
          anime.categories.build(genre_id: genre.id)
        end

        anime_info['casts'].each do |cast|
          cast['people'].each do |person_info|
            person = people_map[person_info['id']]
            character = characters_map[cast['character']['id']]
            locale = LOCALES[person_info['locale']]
            next if person.nil? || character.nil? || locale.nil?

            anime.casts.build(
              locale: locale,
              person_id: person.id,
              character_id: character.id,
              role: cast['role'].downcase
            )
          end
        end

        anime_info['staffs'].each do |staff|
          person = people_map[staff['person']['id']]
          next unless person

          anime.staffs.build(person_id: person.id, role: staff['role'])
        end

        cover_url = anime_info['cover']
        if cover_url.present?
          anime.cover.attach(
            io: open(cover_url),
            filename: File.basename(cover_url)
          )
        end

        anime.save!
      end

      # animes.each do |anime|
      #   anime.run_callbacks(:validation) { false }
      # end

      # Anime.import! animes, recursive: true
    end
  end

  desc 'MyAnimeList dump!'
  task :dump, [:from, :to] => :environment do |t, args|
    from = args[:from].to_i
    to = args[:to].to_i

    base_dir = File.join(MAL_DIR, 'animes').to_s
    FileUtils.mkdir_p(base_dir) unless File.exist?(base_dir)

    (from..to).each do |id|
      anime = MyAnimeList::Anime.new(id)
      begin
        info = anime.get
        puts "dumping anime: #{id}..."
        File.open(File.join(base_dir, "#{id}.json"), 'w') do |f|
          f.write(info.to_json)
        end
      rescue => ex
        puts "error: #{ex.message}"
      end
    end
  end

  desc 'MyAnimeList generate people'
  task :combine, [:from, :to] => :environment do |t, args|
    from = args[:from].to_i
    to = args[:to].to_i

    base_dir = File.join(MAL_DIR, 'animes').to_s

    animes = []
    people = []
    producers = []
    characters = []

    (from..to).each do |id|
      file_path = File.join(base_dir, "#{id}.json")
      if File.exist?(file_path)
        puts "reading anime: #{id}..."
        info = JSON.parse(File.read(file_path))

        people += get_people(info)
        producers += get_producers(info)
        characters += get_characters(info)

        animes << info
      else
        puts "error: can not read anime: #{id}"
      end
    end

    puts "combining from #{from} to #{to}..."

    filename = "#{from}-#{to}.json"
    combine_people(people, filename)
    combine_producers(producers, filename)
    combine_characters(characters, filename)

    File.open(File.join(base_dir, filename), 'w') do |f|
      f.write(animes.to_json)
    end
  end

  def get_anime_info(anime_info)
    {
      titles: anime_info['titles'],
      desc: anime_info['desc'],
      started_at: anime_info['started_at'],
      ended_at: anime_info['ended_at'],
      show_type: anime_info['show_type'],
      age_rating: get_age_rating(anime_info),
      age_rating_guide: anime_info['age_rating_guide'],
      adaptation: anime_info['adaptation'],
      episode_duration: get_episode_duration(anime_info['episode_duration']),
      sub_titles: anime_info['sub_titles']
    }
  end

  def get_age_rating(anime_info)
    {
      'G' => 'G',
      'PG' => 'PG',
      'PG-13' => 'PG',
      'R' => 'R',
      'R+' => 'R18',
      'Rx' => 'R18'
    }[anime_info['age_rating']]
  end

  def get_episode_duration(duration)
    duration.sub(' min', '')
  end

  def get_people(info)
    people = info['casts'].map do |cast|
      next if cast['people'].blank?
      cast['people']
    end.compact

    more_people = info['staffs'].map do |staff|
      next if staff['person'].blank?
      staff['person']
    end.compact

    (people + more_people).flatten
  end

  def get_producers(info)
    info['producers'] + info['studios'] + info['licensors']
  end

  def get_characters(info)
    info['casts'].map do |cast|
      next if cast['character'].blank?
      cast['character']
    end.compact
  end

  def combine_people(people, filename)
    people = remove_duplicate(people)

    people_path = File.join(MAL_DIR, 'people').to_s
    FileUtils.mkdir_p(people_path) unless File.exist?(people_path)

    people_json = people.inject({}) do |json, person|
      json.merge(person['id'] => person['name'])
    end

    File.open(File.join(people_path, filename), 'w') do |f|
      f.write(people_json.to_json)
    end
  end

  def combine_producers(producers, filename)
    producers = producers.uniq

    producers_path = File.join(MAL_DIR, 'producers').to_s
    FileUtils.mkdir_p(producers_path) unless File.exist?(producers_path)

    File.open(File.join(producers_path, filename), 'w') do |f|
      f.write(producers.to_json)
    end
  end

  def combine_characters(characters, filename)
    characters = remove_duplicate(characters)

    characters_path = File.join(MAL_DIR, 'characters').to_s
    FileUtils.mkdir_p(characters_path) unless File.exist?(characters_path)

    characters_json = characters.inject({}) do |json, ch|
      json.merge(ch['id'] => ch['name'])
    end

    File.open(File.join(characters_path, filename), 'w') do |f|
      f.write(characters_json.to_json)
    end
  end

  def remove_duplicate(items)
    item_ids = items.map { |item| item['id'] }.uniq
    items.select { |item| item_ids.include?(item['id']) }
  end
end
