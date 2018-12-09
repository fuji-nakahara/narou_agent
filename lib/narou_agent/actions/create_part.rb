class NarouAgent
  module Actions
    class CreatePart < Action
      def run(ncode, subtitle, body, date = nil, wait_duration = NarouAgent::DEFAULT_WAIT_DURATION)
        driver.get(new_part_url(ncode))

        driver.find_element(name: 'novel').send_keys(body)
        driver.find_element(name: 'subtitle').send_keys(subtitle)

        if !date.nil? && date > Time.now
          driver.script <<~JAVASCRIPT
            $('.hasDatepicker').datepicker('setDate', new Date('#{date.strftime('%F')}'));
          JAVASCRIPT
          Selenium::WebDriver::Support::Select.new(driver.find_element(:name, 'hour')).select_by(:value, date.hour.to_s)
        end

        driver.find_element(css: '#ziwainput[value="次話投稿[確認]"]').click
        driver.find_element(css: '#ziwainput[value="次話投稿[実行]"]').click

        driver.find_element(xpath: '//h2[text()="次話投稿[完了]"]')

        sleep wait_duration

        driver.navigate.to(novel_url(ncode))
        driver.find_element(link: subtitle)['href']
      rescue Selenium::WebDriver::Error::WebDriverError => e
        raise ActionFailedError.new(e)
      end
    end
  end
end
