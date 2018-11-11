require 'selenium-webdriver'

require_relative 'narou_agent/url_helper'
require_relative 'narou_agent/action'
require_relative 'narou_agent/error'
require_relative 'narou_agent/version'

require_relative 'narou_agent/actions/login'

class NarouAgent
  BASE_URL = 'https://syosetu.com'

  attr_reader :base_url, :driver

  def initialize(base_url: BASE_URL, driver: Selenium::WebDriver.for(:chrome))
    @base_url  = base_url
    @driver    = driver
    @logged_in = false
  end

  def logged_in?
    @logged_in
  end

  def login!(id:, password:)
    Actions::Login.new(self).run(id, password)
    @logged_in = true
  end
end
