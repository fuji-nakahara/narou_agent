class NarouAgent
  module Actions
    class Login < Action
      def run(id, password)
        driver.get(login_url)

        driver.find_element(name: 'narouid').send_keys(id)
        driver.find_element(name: 'pass').send_keys(password)

        driver.find_element(id: 'mainsubmit').click

        # Confirm logging in succeeded
        driver.find_element(id: 'userid')
      rescue Selenium::WebDriver::Error::WebDriverError => e
        raise ActionFailedError.new(e)
      end
    end
  end
end
