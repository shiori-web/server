module MyAnimeList
  class CharacterAndStaff
    attr_reader :url, :id

    def initialize(url)
      @url = url
      @id = get_id(url)
    end

    def get
      res = request
      fail "Can not find characters for anime with id '#{id}'" if res.code != '200'
      process(Nokogiri::HTML(res.body))
    end

    def process(node)
      casts_and_staffs = table_for(node, 'Characters & Voice Actors').map { |table| cast(table) }

      casts, staffs = [], []
      roles = ['Main', 'Supporting']

      casts_and_staffs.each do |item|
        if roles.include?(item[:role])
          casts << item
        else
          staffs << { role: item[:role], person: item[:character] }
        end
      end

      { casts: casts, staffs: staffs }
    end

    private

    def cast(table)
      cast_role = table.xpath('.//td[2]/div/small').text.strip
      cast_locale = table.xpath('.//td[1]/small').text.strip

      {
        role: cast_role,
        locale: cast_locale,
        person: person(table),
        character: character(table)
      }
    end

    def staff(table)
      {
        role: table.xpath('.//td[2]/div/small').text.strip,
        person: character(table)
      }
    end

    def person(table)
      {
        id: get_id(table.xpath('.//td[1]/a/@href').text.strip),
        name: table.xpath('.//td[1]/a').text.strip
      }
    end

    def character(table)
      {
        id: get_id(table.xpath('.//td[2]/a/@href').text.strip),
        name: table.xpath('.//td[2]/a').text.strip
      }
    end

    def request
      @res ||= Net::HTTP.get_response(uri)
    end

    def table_for(node, text)
      node.xpath("//td[@valign=\"top\"][.//h2[contains(text(), \"#{text}\")]]//table[.//td[contains(@class, \"ac\")]]")
    end

    def get_id(url)
      match = url.match(/\Ahttps:\/\/.*\/.*\/(\d+)\/.*/)
      match.captures.first if match
    end

    def uri
      begin
        URI.parse(url)
      rescue URI::InvalidURIError
        URI.parse(URI.escape(url))
      end
    end
  end
end
