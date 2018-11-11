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
    end

    private

    def login_url
      "#{base_url}/login/input/"
    end

    def part_url(ncode, id)
      "#{base_url}/usernoveldatamanage/top/ncode/#{UrlHelper.ncode_to_i(ncode)}/noveldataid/#{id}/"
    end

    def edit_part_url(ncode, id)
      "#{base_url}/usernoveldatamanage/updateinput/ncode/#{UrlHelper.ncode_to_i(ncode)}/noveldataid/#{id}/"
    end
  end
end
