# RspecTimer

RSpecTimer will track the amount of time each of your tests take to complete,
and when it's done, can save the data to a YAML file.

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

  config.before(:suite) do
    # Set the log file's path (optional - if not set, defaults to a 'rspec-metrics.yml' file in your current folder)
    RspecTimer.log_file_path = 'rspec_metrics.yml'
  
    # Completely wipes any metrics from the log (optional)
    RspecTimer.reset_metrics_log_file
  end

  config.around(:each) do |example|
    RspecTimer.run_and_measure(example)
  end

  config.after(:suite) do
    # Stores any metrics from this test run into the YAML log file
    # Adds/updates metrics according to unique signatures which are generated
    # using each individual test's line number and source code.
    RspecTimer.update_metrics_log_file
  end

end

```

## Contributing

1. Fork it ( https://github.com/tomchapin/rspec_timer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
