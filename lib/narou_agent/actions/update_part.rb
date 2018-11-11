class NarouAgent
  module Actions
    class UpdatePart < Action
      def run(ncode, part_id, subtitle, body)
        driver.get(edit_part_url(ncode, part_id))

        subtitle_input = driver.find_element(name: 'subtitle')
        subtitle_input.clear
        subtitle_input.send_keys(subtitle)

        novel_textarea = driver.find_element(name: 'novel')
        novel_textarea.clear
        novel_textarea.send_keys(body)

        driver.find_element(css: '#novelmanage[value="編集[確認]"]').click
        driver.find_element(css: '#novelmanage[value="編集[実行]"]').click

        driver.find_element(xpath: '//h2[text()="投稿済み小説編集[完了]"]')

        part_url(ncode, part_id)
      rescue Selenium::WebDriver::Error::WebDriverError => e
        raise ActionFailedError.new(e)
      end
    end
  end
end
