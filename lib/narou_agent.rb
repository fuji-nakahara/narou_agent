require 'selenium-webdriver'

require_relative 'narou_agent/url_helper'
require_relative 'narou_agent/action'
require_relative 'narou_agent/error'
require_relative 'narou_agent/version'

require_relative 'narou_agent/actions/login'
require_relative 'narou_agent/actions/create_part'
require_relative 'narou_agent/actions/update_part'
require_relative 'narou_agent/actions/delete_part'

class NarouAgent
  BASE_URL = 'https://syosetu.com'

  DEFAULT_WAIT_DURATION = 60

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

  def create_part(ncode:, subtitle:, body:, wait_duration: DEFAULT_WAIT_DURATION)
    raise NotLoggedInError unless logged_in?
    Actions::CreatePart.new(self).run(ncode, subtitle, body, wait_duration)
  end

  def update_part(ncode:, part_id:, subtitle:, body:)
    raise NotLoggedInError unless logged_in?
    Actions::UpdatePart.new(self).run(ncode, part_id, subtitle, body)
  end

  def delete_part(ncode:, part_id:)
    raise NotLoggedInError unless logged_in?
    Actions::DeletePart.new(self).run(ncode, part_id)
  end
end
