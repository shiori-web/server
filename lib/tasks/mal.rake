namespace :mal do
  desc 'MyAnimeList dump!'
  task :dump, [:from, :to] => :environment do |t, args|
    from = args[:from].to_i
    to = args[:to].to_i

    base_dir = Rails.root.join('db/data/animes').to_s
    FileUtils.mkdir_p(base_dir) unless File.exist?(base_dir)

    (from..to).each do |id|
      puts "dumping anime: #{id}..."
      anime = MyAnimeList::Anime.new(id)
      begin
        info = anime.get
        File.open(File.join(base_dir, "#{id}.json"), 'w') do |f|
          f.write(info.to_json)
        end
      rescue => ex
        puts "error: #{ex.message}"
      end
    end
  end
end
