require 'net/http'
require 'rank-commiters/config'

module RankCommiters
  class Probe
    URL = 'https://api.github.com/repos/%s/commits'

    def query(repo)
      @results  = []
      @results << get(URI(URL % repo))

      while (link = @results.last.get_fields('Link'))
        links = link.first.split(', ').map do |item|
          [ $2, $1 ] if item.match(/<(.+)>.+\"(.+)\"/)
        end

        next_url = Hash[links]['next']
        break unless next_url

        @results << get(URI(next_url))
      end

      @results
    end

    private

    def get(uri)
      uri.query = URI.encode_www_form(
        access_token: RankCommiters::Config.access_token
      ) unless uri.query

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request = Net::HTTP::Get.new(uri)
        request['Accept'] = 'application/vnd.github.v3+json'

        http.request(request)
      end
    end

  end
end
