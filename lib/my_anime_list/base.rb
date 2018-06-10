module MyAnimeList
  class Base
    attr_reader :id

    class << self
      attr_reader :type, :url

      def inherited(base)
        type = base.name.demodulize.underscore
        url = "https://myanimelist.net/#{type}"
        base.instance_variable_set(:@type, type)
        base.instance_variable_set(:@url, url)
      end
    end

    def initialize(id)
      @id = id
    end

    def get
      res = request
      fail "Can't find #{self.class.type} with id '#{id}'" if res.code != '200'
      process(Nokogiri::HTML(res.body))
    end

    def process(node)
      fail NotImplementedError
    end

    private

    def request
      @res ||= Net::HTTP.get_response(URI("#{self.class.url}/#{id}"))
    end
  end
end
