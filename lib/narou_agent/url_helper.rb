class NarouAgent
  module UrlHelper
    NCODE_PATTERN = /\AN(?<digits>\d{4})(?<alphabets>[A-Z]*)\z/

    class << self
      # See http://syosetu.com/bbstopic/top/topicid/2733/
      def ncode_to_i(ncode)
        match     = ncode.upcase.match(NCODE_PATTERN)
        alphabets = ('A'..'Z').to_a
        match[:digits].to_i + match[:alphabets].chars.reverse.each_with_index.inject(0) do |sum, (alphabet, i)|
          sum += 9999 * alphabets.index(alphabet) * (alphabets.size ** i)
        end
      end

      def extract_part_id(url)
        url[%r{noveldataid/(\d+)}, 1]
      end
    end

    private

    def login_url
      "#{base_url}/login/input/"
    end

    def novel_url(ncode)
      "#{base_url}/usernovelmanage/top/ncode/#{UrlHelper.ncode_to_i(ncode)}/"
    end

    def part_url(ncode, id)
      "#{base_url}/usernoveldatamanage/top/ncode/#{UrlHelper.ncode_to_i(ncode)}/noveldataid/#{id}/"
    end

    def new_part_url(ncode)
      "#{base_url}/usernovelmanage/ziwainput/ncode/#{UrlHelper.ncode_to_i(ncode)}}/"
    end

    def edit_part_url(ncode, id)
      "#{base_url}/usernoveldatamanage/updateinput/ncode/#{UrlHelper.ncode_to_i(ncode)}/noveldataid/#{id}/"
    end

    def delete_part_url(ncode, id)
      "#{base_url}/usernoveldatamanage/deleteconfirm/ncode/#{UrlHelper.ncode_to_i(ncode)}/noveldataid/#{id}/"
    end
  end
end
