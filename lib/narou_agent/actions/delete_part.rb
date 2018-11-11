class NarouAgent
  module Actions
    class DeletePart < Action
      def run(ncode, part_id)
        driver.get(delete_part_url(ncode, part_id))

        driver.find_element(css: 'input[value="削除[実行]"]').click

        driver.find_element(xpath: '//h2[text()="投稿済み連載小説部分削除[完了]"]')
        true
      rescue Selenium::WebDriver::Error::WebDriverError => e
        raise ActionFailedError.new(e)
      end
    end
  end
end
