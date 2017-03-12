# mina-instana

Send [Mina](http://nadarei.co/mina/) deploy events to Instana.

![instana deploy notification started 2017-03-12 at 15 08 10](https://cloud.githubusercontent.com/assets/395132/23832516/063eab12-0736-11e7-9862-071649928131.png)
![instana deploy notification finished 2017-03-12 at 15 07 00](https://cloud.githubusercontent.com/assets/395132/23832517/0646b262-0736-11e7-9388-1525329ecd5c.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mina-instana'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mina-instana

## Usage

Add the following to your `config/deploy.rb`
```
require 'mina/instana'
```
Deploy...

Profit!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/instana/mina-instana.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

