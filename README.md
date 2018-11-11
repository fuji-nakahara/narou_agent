# NarouAgent

Selenium script for [小説家になろう](https://syosetu.com/) novel management.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'narou_agent'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install narou_agent

## Usage

```ruby
require 'narou_agent'

agent = NarouAgent.new(driver: Selenium::WebDriver.for(:chrome))

# ログイン
agent.login!(id: YOUR_ID, password: YOUR_PASSWORD) 

# 連載小説のNコード
ncode = 'N8472FC'

# 次話投稿
part_url = agent.create_part(ncode: ncode, subtitle: 'サブタイトル', body: '本文')

# URL から part_id を抽出
part_id = NarouAgent::UrlHelper.extract_part_id(part_url) 

# 編集
agent.update_part(ncode: ncode, part_id: part_id, subtitle: '新しいサブタイトル', body: '新しい本文')

# 削除
agent.delete_part(ncode: ncode, part_id: part_id) 
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fuji-nakahara/narou_agent. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the NarouAgent project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/fuji-nakahara/narou_agent/blob/master/CODE_OF_CONDUCT.md).
