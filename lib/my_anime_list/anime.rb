module MyAnimeList
  class Anime < Base
    def process(node)
      data = dates(node).merge(
        rating(node)
      )

      data.merge(
        cover: cover(node),
        titles: titles(node),
        show_type: show_type(node),
        sub_titles: sub_titles(node),
        producers: producers(node),
        studios: studios(node),
        licensors: licensors(node),
        genres: genres(node)
      )
    end

    private

    def titles(node)
      en_jp = node.xpath('//h1/span[@itemprop="name"]').text.strip
      en = no_link_info(node, 'English')
      ja_jp = no_link_info(node, 'Japanese')
      { en: en, en_jp: en_jp, ja_jp: ja_jp }.select { |_, value| value.present? }
    end

    def sub_titles(node)
      content = no_link_info(node, 'Synonyms')
      content.split(',').map(&:strip)
    end

    def cover(node)
      url = node.xpath('//img[@itemprop="image"]/@src').text.strip
      { io: open(url), filename: File.basename(url) }
    end

    def show_type(node)
      link_info(node, 'Type')
    end

    def adaptation(node)
      no_link_info(node, 'Source')
    end

    def episode_duration(node)
      no_link_info(node, 'Duration').split('.').first
    end

    def rating(node)
      age, guide = no_link_info(node, 'Rating').split(' - ')
      { age_rating: age, age_rating_guide: guide }
    end

    def producers(node)
      info_links(node, 'Producers')
    end

    def studios(node)
      info_links(node, 'Studios')
    end

    def genres(node)
      info_links(node, 'Genres')
    end

    def licensors(node)
      info_links(node, 'Licensors')
    end

    def dates(node)
      date_range = node.xpath('//div[./span[contains(text(), "Aired:")]]/text()').text.strip
      started_at, ended_at = date_range.split('to').map { |date_str| parse_date(date_str.strip) }.compact
      { started_at: started_at, ended_at: ended_at }
    end

    def link_info(node, text)
      info_link(node, text).text.strip
    end

    def no_link_info(node, text)
      selector = "//div[./span[contains(text(), \"#{text}\")]]/text()"
      node.xpath(selector).text.strip
    end

    def info_link(node, text)
      node.xpath("//div[./span[contains(text(), \"#{text}\")]]/a")
    end

    def info_links(node, text)
      info_link(node, text).map do |a|
        next if a.text.strip == 'add some'
        a.text.strip
      end.compact
    end

    def parse_date(date_str)
      begin
        Date.parse(date_str)
      rescue
        nil
      end
    end
  end
end
