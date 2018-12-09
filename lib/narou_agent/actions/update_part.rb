class NarouAgent
  module Actions
    class UpdatePart < Action
      def run(ncode, part_id, subtitle, body, date = nil)
        driver.get(edit_part_url(ncode, part_id))

        driver.find_element(name: 'subtitle').tap do |subtitle_input|
          subtitle_input.clear
          subtitle_input.send_keys(subtitle)
        end
        driver.find_element(name: 'novel').tap do |novel_textarea|
          novel_textarea.clear
          novel_textarea.send_keys(body)
        end

        if !date.nil? && date > Time.now
          driver.script <<~JAVASCRIPT
            $('.hasDatepicker').datepicker('setDate', new Date('#{date.strftime('%F')}'));
          JAVASCRIPT
          Selenium::WebDriver::Support::Select.new(driver.find_element(:name, 'hour')).select_by(:value, date.hour.to_s)
        end

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
