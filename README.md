# Helium::Console

It is really tricky to display data in the console in the readable and consistent way. Many objects needs to display other objects, which might break their own formatting.
Helium:Console is an attempt to make your development console more readable by:
* limiting displayed nesting levels (currently set to 3 level of nesting)
* using nested table layout

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

You can start helium console same way as you would start Pry:

``` ruby
require 'helium/console'
Helium::Console.start!
```    

### Custom formatters

Helium::Console hooks into pry and brings a number of default formatters. Unlike IRB and Pry, it does not use object's methods for display
(so no `inspect` nor `pretty_print`) and replaces them by the collection of inheritable formatters objects stored in its registry.

Formatter can be any object that conforms to the following interface:
* `initialize(object_to_format, console_instance, **options)`
* `call` method returning any object responding to `lines` (e.g. `String` )

Formatter bellow will simply return a result of `inspect` call on the object:

```ruby
class InspectFormatter
  def initialize(object, _console, **)
    @object = object
  end
  
  def call
    @object.inspect
  end
end
```

You can register your formatter in console registry with:

```ruby
Helium::Console.register(Kernel, InspectFormatter)
```

The call above makes `InspectFormatter` available for all the objects that derives from Kernel module.

To make formatting easier, you can subclass your formatter from `Helium::Console::Registry::Element`. By doing so, the following methods will be available to you inside your formatter class:
* `object`, `console` and `options` readers
* `format(other_object, **options)` - formats some other object **using the exact same options, including nesting level**.
* `format_nested(other_object, **options)` - as above, but increases nesting level.
* `format_string(string, **options)` - formats string by splitting it into lines of appropriate length and truncating (depending on nesting level).
This is different to `format` and `format_nested` as it will not trigger `String` formatter (which by default adds quotes, escapes inner quotes and colors the result light green)
* `red(string)`, `light_red(string)`, `yellow(string)`, etc - returns colorized string when `Pry.color` is set to true.
* `length_of(string)` - utility option returning the length of displayed string, handling both colorized and non-colorized strings.

### Displaying as a table

To display object in a form of a table, format instance of `Helium::Console::Table`:

```ruby
class MyFormatter < Helium::Console::Registry::Element
  def call
    table = Helium::Console::Table.new(runner: '--@', after_key: '--@--', format_keys: false)
    table.row magenta("property 1"), object.prop1
    table.row magenta("property 2"), object.instance_variable_get(:@prop2)
    
    format table
  end
end
```

Table will automatically format all the right-hand values with an increased nesting level. By default, it will also format the left-hand keys, however this is controlled with `format_keys` option.

Other options: `runner` is a string to be displayed at the beginning of each line, and `after_key` is a string to be injected between left and right values.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/helium-console. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/helium-console/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Helium::Console project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/helium-console/blob/master/CODE_OF_CONDUCT.md).
