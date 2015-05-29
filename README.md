# RspecTimer

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec_timer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec_timer

## Usage

In your spec_helper.rb file, set up your "around" and "after" hooks like so:

```ruby

RSpec.configure do |config|

  config.around(:each) do |example|
      RspecTimer.run_and_measure(example)
  end

  config.after(:suite) do
    RspecTimer.save_metrics_to_file(Rails.root.join('rspec_metrics.yml').to_s)
  end

end

```

## Contributing

1. Fork it ( https://github.com/tomchapin/rspec_timer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
