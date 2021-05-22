# Helium::Console

It is really tricky to display data in the console in the readable and consistent way. Many objects needs to display other objects, which might break their own formatting.
Helium:Console is to make it easier by formatting strings in accordance to current console size.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'helium-console'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install helium-console

## Usage

Helium::Console helps you to format any string in such a way that it displays nicely in the console:

```
string = "- Hello there!\nGeneral Kenobi"
Helium::Console.format(string, indent: 2)
=> "  - Hello there!\n  General Kenobi"
```

When executed in a non-console environment `format` simply returns the string.

Supported formattign options:

* `indent` - specifies the amount of spaces added to each new line. Also accepts hash `{first:, other:}`. Defaults to 0.
* `overflow` - specifies how to handle lines longer than console line width.
  * `:wrap` - splits the long line into few lines and applies the required indent.
  * `:wrap_words` - similar to wrap, but will try to avoid breaking the words.
  * `:none` - does not modify long strings.
* `max-lines` - specifies how many lines to display. Last line will be truncated with `...`. Defaults to `nil`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/helium-console. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/helium-console/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Helium::Console project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/helium-console/blob/master/CODE_OF_CONDUCT.md).
