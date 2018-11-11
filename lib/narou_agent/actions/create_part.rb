class NarouAgent
  module Actions
    class CreatePart < Action
      def run(ncode, subtitle, body, wait_duration)
        driver.get(new_part_url(ncode))

        driver.find_element(name: 'novel').send_keys(body)
        driver.find_element(name: 'subtitle').send_keys(subtitle)

        driver.find_element(css: '#ziwainput[value="次話投稿[確認]"]').click
        driver.find_element(css: '#ziwainput[value="次話投稿[実行]"]').click

        driver.find_element(xpath: '//h2[text()="次話投稿[完了]"]')

        sleep wait_duration

        driver.navigate.to(novel_url(ncode))
        driver.find_element(link: subtitle).attribute('href')
      rescue Selenium::WebDriver::Error::WebDriverError => e
        raise ActionFailedError.new(e)
      end
    end
  end
end
